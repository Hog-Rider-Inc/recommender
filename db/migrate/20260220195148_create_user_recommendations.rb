class CreateUserRecommendations < ActiveRecord::Migration[8.1]
  def up
    execute <<-SQL
      CREATE TABLE user_recommendations (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        item_id INT NOT NULL,
        created_at datetime(6) NOT NULL,
        updated_at datetime(6) NOT NULL
      );
    SQL
  end

  def down
    execute <<-SQL
      DROP TABLE user_recommendations;
    SQL
  end
end
