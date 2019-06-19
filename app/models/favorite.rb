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
            SELECT favorites.*,
            favorites.id AS favorite_id,
            comments.note
            FROM favorites
            LEFT JOIN comments
            ON favorites.id = comments.favorite_id
            ORDER BY favorites.id ASC;
            SQL
        )

        return results.map do |result|
            if result["favorite_id"]
                note = {
                    "id" => result["favorite_id"].to_i,
                    "note" => result["note"]
                }
            end
            {
              "id" => result["id"].to_i,
              "name" => result["name"],
              "shortname" => result["shortname"],
              "address" => result["address"],
              "city" => result["city"],
              "note" => note
            }
        end
    end
    def self.find(id)
        results = DB.exec(
          <<-SQL
              SELECT favorites.*,
              favorites.id AS favorite_id,
              comments.note
              FROM favorites
              LEFT JOIN comments
              ON favorites.id = comments.favorite_id
              WHERE favorites.id=#{id};
          SQL
        )
        result = results.first
        if result["favorite_id"]
            note = {
                "id" => result["favorite_id"].to_i,
                "note" => result["note"]
            }
        end
        return {
            "id" => result["id"].to_i,
            "name" => result["name"],
            "shortname" => result["shortname"],
            "address" => result["address"],
            "city" => result["city"],
            "note" => note
        }
    end
    def self.create(opts)
        results = DB.exec(
            <<-SQL
                INSERT INTO favorites (name, shortname, address, city)
                VALUES ( '#{opts["name"]}', '#{opts["shortname"]}', '#{opts["address"]}', '#{opts["city"]}' )
                RETURNING id, name, shortname, address, city;
            SQL
        )
        return {
            "id" => results.first["id"].to_i,
            "name" => results.first["name"],
            "shortname" => results.first["shortname"],
            "address" => results.first["address"],
            "city" => results.first["city"],
            "favorite_id" => results.first["favorite_id"],
            "note" => results.first["note"]
        }
    end
    def self.delete(id)
        results = DB.exec("DELETE FROM favorites WHERE id=#{id};")
        return { "deleted" => true }
    end

    def self.update(id, opts)
        results = DB.exec(
            <<-SQL
                UPDATE favorites
                SET name='#{opts["name"]}', shortname='#{opts["shortname"]}', address='#{opts["address"]}', city='#{opts["city"]}'
                WHERE id=#{id}
                RETURNING id, name, shortname, address, city, favorite_id, note;
            SQL
        )
        return {
            "id" => results.first["id"].to_i,
            "name" => results.first["name"],
            "shortname" => results.first["shortname"],
            "address" => results.first["address"],
            "city" => results.first["city"],
            "favorite_id" => results.first["favorite_id"],
            "note" => results.first["note"]
        }
    end

end
