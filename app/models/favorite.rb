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
              "id" => result["id"].to_i,
              "name" => result["name"],
              "shortname" => result["shortname"],
              "address" => result["address"],
              "city" => result["city"],
              "comments" => result["comments"]
            }
        end
    end
    def self.find(id)
        results = DB.exec(
          <<-SQL
              SELECT
                * FROM favorites
              WHERE id=#{id};
          SQL
        )
        return {
            "id" => results.first["id"].to_i,
            "name" => results.first["name"],
            "shortname" => results.first["shortname"],
            "address" => results.first["address"],
            "city" => results.first["city"],
            "comments" => results.first["comments"]
        }
    end
    def self.create(opts)
        results = DB.exec(
            <<-SQL
                INSERT INTO favorites (name, shortname, address, city)
                VALUES ( '#{opts["name"]}', '#{opts["shortname"]}', '#{opts["address"]}', '#{opts["city"]}', '#{opts["comments"]}' )
                RETURNING id, name, shortname, address, city, comments;
            SQL
        )
        return {
            "id" => results.first["id"].to_i,
            "name" => results.first["name"],
            "shortname" => results.first["shortname"],
            "address" => results.first["address"],
            "city" => results.first["city"],
            "comments" => results.first["comments"]
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
                SET name='#{opts["name"]}', shortname='#{opts["shortname"]}', address='#{opts["address"]}', city='#{opts["city"]}', comments='#{opts["comments"]}'
                WHERE id=#{id}
                RETURNING id, name, shortname, address, city, comments;
            SQL
        )
        return {
            "id" => results.first["id"].to_i,
            "name" => results.first["name"],
            "shortname" => results.first["shortname"],
            "address" => results.first["address"],
            "city" => results.first["city"],
            "comments" => results.first["comments"]
        }
    end

end
