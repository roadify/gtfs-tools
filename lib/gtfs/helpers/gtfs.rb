module GTFSHelper

  def create( params )

    database = params[:database]

    statements = case params[:table]

      when "agencies" then [
        'CREATE TABLE IF NOT EXISTS `agencies` ( `id` text, `name` text, `url` text, `timezone` text, `language` text, `phone_number` text, `fare_url` text, `bikes_policy_url` text );',
        'CREATE UNIQUE INDEX IF NOT EXISTS `pk_agencies` ON `agencies` (`id`);'
      ]

      when "calendars" then [
        'CREATE TABLE IF NOT EXISTS `calendars` ( `id` text, `name` text, `monday` text, `tuesday` text, `wednesday` text, `thursday` text, `friday` text, `saturday` text, `sunday` text, `start_date` text, `end_date` text );',
        'CREATE UNIQUE INDEX IF NOT EXISTS `pk_calendars` ON `calendars` (`id`);'
      ]

      when "calendar_dates" then [
        'CREATE TABLE IF NOT EXISTS `calendar_dates` ( `calendar_id` text, `date` text, `exception_type` text );'
      ]

      when "fares" then [
        'CREATE TABLE IF NOT EXISTS `fares` ( `id` text, `agency_id` text, `price` text, `descriptions` text, `currency_type` text, `payment_method` text, `transfers` text, `transfer_duration` text );',
        'CREATE UNIQUE INDEX IF NOT EXISTS `pk_fares` ON `fares` (`id`);'
      ]

      when "fare_rules" then [
        'CREATE TABLE IF NOT EXISTS `fare_rules` ( `fare_id` text, `route_id` text, `origin_id` text, `destination_id` text, `contains_id` text );'
      ]

      when "feeds" then [
        'CREATE TABLE IF NOT EXISTS `feeds` ( `publisher_name` text, `publisher_url` text, `language` text, `start_date` text, `end_date` text, `version` text, `id` text );',
        'CREATE UNIQUE INDEX IF NOT EXISTS `pk_feeds` ON `feeds` (`id`);'
      ]

      when "frequencies" then [
        'CREATE TABLE IF NOT EXISTS `frequencies` ( `trip_id` text, `start_time` text, `end_time` text, `headway_seconds` text, `exact_times` text );'
      ]

      when "pattern_pairs" then [
        'CREATE TABLE IF NOT EXISTS `pattern_pairs` ( `route_id_1` text, `route_id_2` text, `stop_id` text, `pattern_id_1` text, `pattern_id_2` text );'
      ]

      when "realtime_feeds" then [
        'CREATE TABLE IF NOT EXISTS `realtime_feeds` ( `url` text, `trip_updates` text, `alerts` text, `vehicle_positions` text );',
        'CREATE UNIQUE INDEX IF NOT EXISTS `pk_realtime_feeds` ON `realtime_feeds` (`url`);'
      ]

      when "routes" then [
        'CREATE TABLE IF NOT EXISTS `routes` ( `id` text, `agency_id` text, `short_name` text, `long_name` text, `description` text, `type` text, `url` text, `color` text, `text_color` text, `sort_order` text );',
        'CREATE UNIQUE INDEX IF NOT EXISTS `pk_routes` ON `routes` (`id`);'
      ]

      when "route_directions" then [
        'CREATE TABLE IF NOT EXISTS `route_directions` ( `route_id` text, `direction_id` text, `direction_name` text );',
        'CREATE UNIQUE INDEX IF NOT EXISTS `pk_route_directions` ON `route_directions` (`route_id`, `direction_id`);'
      ]

      when "shapes" then [
        'CREATE TABLE IF NOT EXISTS `shapes` ( `id` text, `latitude` text, `longitude` text, `sequence` text, `distance_traveled` text );',
        'CREATE UNIQUE INDEX IF NOT EXISTS `pk_shapes` ON `shapes` (`id`,`sequence`);'
      ]

      when "stop_features" then [
        'CREATE TABLE IF NOT EXISTS `stop_features` ( `stop_id` text, `feature_type` text, `feature_name` text );'
      ]

      when "stop_times" then [
        'CREATE TABLE IF NOT EXISTS `stop_times` ( `trip_id` text, `arrival_time` text, `departure_time` text, `stop_id` text, `stop_sequence` text, `stop_headsign` text, `pickup_type` text, `drop_off_type` text, `shape_distance_traveled` text, `timepoint` text, `continuous_stops` text );'
      ]

      when "stops" then [
        'CREATE TABLE IF NOT EXISTS `stops` ( `id` text, `code` text, `name` text, `description` text, `latitude` text, `longitude` text, `zone_id` text, `url` text, `location_type` text, `parent_station` text, `direction` text, `position` text, `timezone` text );',
        'CREATE UNIQUE INDEX IF NOT EXISTS `pk_stops` ON `stops` (`id`);'
      ]

      when "transfers" then [
        'CREATE TABLE IF NOT EXISTS `transfers` ( `from_stop_id` text, `to_stop_id` text, `type` text, `minimum_transfer_time` text );',
        'CREATE UNIQUE INDEX IF NOT EXISTS `pk_transfers` ON `transfers` (`from_stop_id`,`to_stop_id`);'
      ]

      when "trips" then [
        'CREATE TABLE IF NOT EXISTS `trips` ( `id` text, `route_id` text, `calendar_id` text, `headsign` text, `short_name` text, `direction_id` text, `block_id` text, `shape_id` text, `type` text, `wheelchair_accessible` text );',
        'CREATE UNIQUE INDEX IF NOT EXISTS `pk_trips` ON `trips` (`id`);'
      ]

      else []

    end

    statements.each { |statement| database.execute statement }

  end

  def table( params )

    case params[:file]
      when "agency.txt" then return "agencies"
      when "pattern_pairs.txt" then return "pattern_pairs"
      when "routes.txt" then return "routes"
      when "shapes.txt" then return "shapes"
      when "stop_times.txt" then return "stop_times"
      when "stops.txt" then return "stops"
      when "trips.txt" then return "trips"
      when "calendar.txt" then return "calendars"
      when "calendar_dates.txt" then return "calendar_dates"
      when "fare_attributes.txt" then return "fares"
      when "fare_rules.txt" then return "fare_rules"
      when "feed_info.txt" then return "feeds"
      when "frequencies.txt" then return "frequencies"
      when "transfers.txt" then return "transfers"
      when "realtime_feeds.txt" then return "realtime_feeds"
      when "route_directions.txt" then return "route_directions"
      when "stop_features.txt" then return "stop_features"
    end

    nil

  end

  def columns( params )

    case params[:file]
      when "agency.txt" then return %w( agency_id agency_name agency_url agency_timezone agency_lang agency_phone agency_fare_url bikes_policy_url )
      when "pattern_pairs.txt" then return %w( route_num_1 route_num_2 stop_id pattern_id_1 pattern_id_2 )
      when "routes.txt" then return %w( agency_id route_id route_short_name route_long_name route_desc route_type route_url route_color route_text_color route_sort_order )
      when "shapes.txt" then return %w( shape_id shape_pt_lat shape_pt_lon shape_pt_sequence shape_dist_traveled )
      when "stop_times.txt" then return %w( trip_id stop_id arrival_time departure_time stop_sequence stop_headsign pickup_type drop_off_type shape_dist_traveled timepoint continuous_stops )
      when "stops.txt" then return %w( stop_id stop_code stop_name stop_desc stop_lat stop_lon zone_id stop_url location_type parent_station direction position stop_timezone )
      when "trips.txt" then return %w( route_id service_id trip_id trip_headsign trip_short_name direction_id block_id shape_id trip_type wheelchair_accessible )
      when "calendar.txt" then return %w( service_id service_name monday tuesday wednesday thursday friday saturday sunday start_date end_date )
      when "calendar_dates.txt" then return %w( service_id date exception_type )
      when "fare_attributes.txt" then return %w( agency_id fare_id price descriptions currency_type payment_method transfers transfer_duration )
      when "fare_rules.txt" then return %w( fare_id route_id origin_id destination_id contains_id )
      when "feed_info.txt" then return %w( feed_publisher_name feed_publisher_url feed_lang feed_start_date feed_end_date feed_version feed_id )
      when "frequencies.txt" then return %w( trip_id start_time end_time headway_secs exact_times )
      when "transfers.txt" then return %w( from_stop_id to_stop_id transfer_type min_transfer_time )
      when "realtime_feeds.txt" then return %w( url trip_updates alerts vehicle_positions )
      when "route_directions.txt" then return %w( route_id direction_id direction_name )
      when "stop_features.txt" then return %w( stop_id feature_type feature_name )
    end

    case params[:table]
      when "agencies" then return %w( id name url timezone language phone_number fare_url bikes_policy_url )
      when "pattern_pairs" then return %w( route_id_1 route_id_2 stop_id pattern_id_1 pattern_id_2 )
      when "routes" then return %w( agency_id id short_name long_name description type url color text_color sort_order )
      when "shapes" then return %w( id latitude longitude sequence distance_traveled )
      when "stop_times" then return %w( trip_id stop_id arrival_time departure_time stop_sequence stop_headsign pickup_type drop_off_type shape_distance_traveled timepoint continuous_stops )
      when "stops" then return %w( id code name description latitude longitude zone_id url location_type parent_station direction position timezone )
      when "trips" then return %w( route_id calendar_id id headsign short_name direction_id block_id shape_id type wheelchair_accessible )
      when "calendars" then return %w( id name monday tuesday wednesday thursday friday saturday sunday start_date end_date )
      when "calendar_dates" then return %w( calendar_id date exception_type )
      when "fares" then return %w( agency_id id price descriptions currency_type payment_method transfers transfer_duration )
      when "fare_rules" then return %w( fare_id route_id origin_id destination_id contains_id )
      when "feeds" then return %w( publisher_name publisher_url language start_date end_date version id )
      when "frequencies" then return %w( trip_id start_time end_time headway_seconds exact_times )
      when "transfers" then return %w( from_stop_id to_stop_id type minimum_transfer_time )
      when "realtime_feeds" then return %w( url trip_updates alerts vehicle_positions )
      when "route_directions" then return %w( route_id direction_id direction_name )
      when "stop_features" then return %w( stop_id feature_type feature_name )
    end

    nil

  end

end
