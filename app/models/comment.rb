class Comment
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
              * FROM comments;
            SQL
        )

        return results.map do |result|
            {
              "id" => result["id"].to_i,
              "note" => result["note"],
              "favorite_id" => result["favorite_id"].to_i
            }
        end
    end
    def self.find(id)
        results = DB.exec(
          <<-SQL
              SELECT
                * FROM comments
              WHERE id=#{id};
          SQL
        )
        return {
            "id" => results.first["id"].to_i,
            "note" => results.first["note"],
            "favorite_id" => results.first["favorite_id"].to_i
        }
    end
    def self.create(opts)
        results = DB.exec(
            <<-SQL
                INSERT INTO comments (note, favorite_id)
                VALUES ( '#{opts["note"]}', #{opts["favorite_id"]} )
                RETURNING id, note, favorite_id;
            SQL
        )
        return {
            "id" => results.first["id"].to_i,
            "note" => results.first["note"],
            "favorite_id" => results.first["favorite_id"].to_i
        }
    end
    def self.delete(id)
        results = DB.exec("DELETE FROM comments WHERE id=#{id};")
        return { "deleted" => true }
    end

    def self.update(id, opts)
        results = DB.exec(
            <<-SQL
                UPDATE comments
                SET note='#{opts["note"]}'
                WHERE id=#{id}
                RETURNING id, note, favorite_id;
            SQL
        )
        return {
            "id" => results.first["id"].to_i,
            "note" => results.first["note"],
            "favorite_id" => results.first["favorite_id"].to_i
        }
    end

end
