class Favorite
    if(ENV['DATABASE_URL'])
        uri = URI.parse(ENV['DATABASE_URL'])
        DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
    else
        DB = PG.connect({:host => "localhost", :port => 5432, :dbname => 'pick4me_development'})
    end

    def self.all
        results = DB.exec(
            <<-SQL
            SELECT
              * FROM favorites;
            SQL
        )

        return results.map do |result|
            {
              "entry_id" => result["entry_id"].to_i,
              "date" => result["date"],
              "brand" => result["brand"],
              "origin" => result["origin"],
              "location" => result["location"],
              "rating" => result["rating"].to_i,
              "favorite" => result["favorite"],
              "flavors" => result["flavors"]
            }
        end
    end
    def self.find(id)
        results = DB.exec(
          <<-SQL
              SELECT
                * FROM favorites
              WHERE entry_id=#{id};
          SQL
        )
        return {
            "entry_id" => results.first["entry_id"].to_i,
            "date" => results.first["date"],
            "brand" => results.first["brand"],
            "origin" => results.first["origin"],
            "location" => results.first["location"],
            "rating" => results.first["rating"].to_i,
            "favorite" => results.first["favorite"],
            "flavors" => results.first["flavors"]
        }
    end
    def self.create(opts)
        results = DB.exec(
            <<-SQL
                INSERT INTO favorites (date, brand, origin, location, rating, favorite, flavors)
                VALUES ( '#{opts["date"]}', '#{opts["brand"]}', '#{opts["origin"]}', '#{opts["location"]}', #{opts["rating"]}, #{opts["favorite"]}, '#{opts["flavors"]}' )
                RETURNING entry_id, date, brand, origin, location, rating, favorite, flavors;
            SQL
        )
        return {
            "entry_id" => results.first["entry_id"].to_i,
            "date" => results.first["date"],
            "brand" => results.first["brand"],
            "origin" => results.first["origin"],
            "location" => results.first["location"],
            "rating" => results.first["rating"].to_i,
            "favorite" => results.first["favorite"],
            "flavors" => results.first["flavors"]
        }
    end
    def self.delete(id)
        results = DB.exec("DELETE FROM favorites WHERE entry_id=#{id};")
        return { "deleted" => true }
    end

    def self.update(id, opts)
        results = DB.exec(
            <<-SQL
                UPDATE favorites
                SET date='#{opts["date"]}', brand='#{opts["brand"]}', origin='#{opts["origin"]}', location='#{opts["location"]}', rating=#{opts["rating"]},
                favorite=#{opts["favorite"]},
                flavors='#{opts["flavors"]}'
                WHERE entry_id=#{id}
                RETURNING entry_id, date, brand, origin, location, rating, favorite, flavors;
            SQL
        )
        return {
            "entry_id" => results.first["entry_id"].to_i,
            "date" => results.first["date"],
            "brand" => results.first["brand"],
            "origin" => results.first["origin"],
            "location" => results.first["location"],
            "rating" => results.first["rating"].to_i,
            "favorite" => results.first["favorite"],
            "flavors" => results.first["flavors"]
        }
    end

end
