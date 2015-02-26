#!/usr/bin/env ruby

require "sqlite3"
require "csv"

require File.join(File.dirname(File.dirname(File.realpath(__FILE__))),"lib","gtfs","helpers","gtfs")

include GTFSHelper

def wait_for( thread )

  spinner = %w( | / - \\ )

  while thread.alive?
    printf spinner.first
    sleep 0.1
    printf "\b"
    spinner.push( spinner.shift )
  end

  thread.join

end

database_name = ARGV.empty? ? "default" : ARGV.first
workspace_path = File.join( Dir.pwd, database_name )
processing_path = File.join( workspace_path, "files", "processing" )

if Dir.exist?( processing_path )

  processing_dir = Dir.new( processing_path )

  processing_dir.each do |file_name|

    file_path = File.join( processing_path, file_name )

    if File.file?( file_path )

      table_name = table( :file => file_name )

      unless table_name
        printf "\x1B[2mprocess\x1B[0m \x1B[1m#{database_name}\x1B[0m \x1B[2m<-\x1B[0m \x1B[33m#{file_name}\x1B[0m "
        printf "\x1B[2mignored\x1B[0m\n"
        next
      end

      printf "\x1B[2mprocess\x1B[0m \x1B[1m#{database_name}\x1B[0m\x1B[2m.\x1B[0m#{table_name} \x1B[2m<-\x1B[0m \x1B[33m#{file_name}\x1B[0m "

      wait_for( Thread.new do

        database_path = File.join( workspace_path, "database" )

        begin

          database = SQLite3::Database.new database_path

          create( :database => database, :table => table_name )

          file_columns = columns( :file => file_name )
          table_columns = columns( :table => table_name )

          column_sequence = nil

          CSV.foreach( file_path ) do |row|

            next if row.nil? || row.empty?

            unless column_sequence
              missing_columns = row.select { |column| !file_columns.include?( column ) }
              unless missing_columns.empty?
                raise "Missing column mappings: #{missing_columns}"
              end
              column_sequence = row.map do |file_column|
                column_index = file_columns.index( file_column )
                table_columns[column_index]
              end.select { |item| !item.nil? }.join(',')
              next
            end

            bound_parameter_placeholder = Array.new(row.size).fill('?').join(',')
            statement_placeholder = "INSERT OR REPLACE INTO #{table_name} (#{column_sequence}) VALUES (#{bound_parameter_placeholder})"

            begin
              statement = database.prepare statement_placeholder
              row.size.times { |i| statement.bind_param i + 1, row[i] }
              statement.execute
            ensure
              statement.close unless statement.nil?
            end

          end

          printf "\b\x1B[1;32mOK\x1B[0m\n"

        rescue Exception => exception

          printf "\b\x1B[1;31mERROR\x1B[0m\n        \x1B[31m#{exception}\x1B[0m\n"

        ensure

          database.close if database

        end

      end )

    end

  end

end
