# rubocop:disable Metrics/ClassLength
class CreateInitialSchema < ActiveRecord::Migration[8.1]
  def up
    statements = [
      # Tables + indexes/uniques
      <<~SQL,
        CREATE TABLE `Accounts` (
          `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `account_type` ENUM('client', 'restaurant') NOT NULL,
          `username` VARCHAR(255) NOT NULL,
          `email` VARCHAR(255) NOT NULL,
          `password_hash` VARCHAR(255) NOT NULL,
          `updated_at` DATETIME(6) NOT NULL,
          `created_at` DATETIME(6) NOT NULL
        )
      SQL
      <<~SQL,
        ALTER TABLE `Accounts`
          ADD UNIQUE `accounts_username_unique` (`username`),
          ADD UNIQUE `accounts_email_unique` (`email`)
      SQL
      <<~SQL,
        CREATE TABLE `Address` (
          `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `country` VARCHAR(20) NOT NULL,
          `city` VARCHAR(50) NOT NULL,
          `street` VARCHAR(50) NOT NULL,
          `postal_code` VARCHAR(15) NOT NULL,
          `updated_at` DATETIME(6) NOT NULL,
          `created_at` DATETIME(6) NOT NULL
        )
      SQL
      <<~SQL,
        ALTER TABLE `Address`
          ADD UNIQUE `address_country_city_street_postal_code_unique` (`country`, `city`, `street`, `postal_code`)
      SQL
      <<~SQL,
        CREATE TABLE `Clients` (
          `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `account_id` BIGINT UNSIGNED NOT NULL,
          `address_id` BIGINT UNSIGNED NULL,
          `first_name` VARCHAR(255) NOT NULL,
          `last_name` VARCHAR(255) NOT NULL,
          `phone_number` VARCHAR(255) NULL,
          `updated_at` DATETIME(6) NOT NULL,
          `created_at` DATETIME(6) NOT NULL
        )
      SQL
      <<~SQL,
        ALTER TABLE `Clients`
          ADD UNIQUE `clients_account_id_unique` (`account_id`),
          ADD UNIQUE `clients_phone_number_unique` (`phone_number`)
      SQL
      <<~SQL,
        CREATE TABLE `Restaurants` (
          `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `account_id` BIGINT UNSIGNED NOT NULL,
          `address_id` BIGINT UNSIGNED NOT NULL,
          `name` VARCHAR(255) NOT NULL,
          `description` VARCHAR(255) NULL,
          `phone_number` VARCHAR(255) NOT NULL,
          `updated_at` DATETIME(6) NOT NULL,
          `created_at` DATETIME(6) NOT NULL
        )
      SQL
      <<~SQL,
        ALTER TABLE `Restaurants`
          ADD UNIQUE `restaurants_account_id_unique` (`account_id`)
      SQL
      <<~SQL,
        CREATE TABLE `MenuItems` (
          `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `restaurant_id` BIGINT UNSIGNED NOT NULL,
          `name` VARCHAR(255) NOT NULL,
          `description` VARCHAR(255) NOT NULL,
          `price` DECIMAL(8, 2) NOT NULL,
          `updated_at` DATETIME(6) NOT NULL,
          `created_at` DATETIME(6) NOT NULL
        )
      SQL
      <<~SQL,
        ALTER TABLE `MenuItems`
          ADD INDEX `menuitems_restaurant_id_index` (`restaurant_id`),
          ADD INDEX `menuitems_name_index` (`name`)
      SQL
      <<~SQL,
        CREATE TABLE `MenuItemImages` (
          `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `menu_item_id` BIGINT UNSIGNED NOT NULL,
          `image_url` VARCHAR(255) NOT NULL,
          `updated_at` DATETIME(6) NOT NULL,
          `created_at` DATETIME(6) NOT NULL
        )
      SQL
      <<~SQL,
        CREATE TABLE `Orders` (
          `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `client_id` BIGINT UNSIGNED NOT NULL,
          `restaurant_id` BIGINT UNSIGNED NOT NULL,
          `address_id` BIGINT UNSIGNED NOT NULL,
          `status` ENUM(
            'pending_acceptance',
            'preparing',
            'prepared',
            'in_delivery',
            'delivered',
            'canceled'
          ) NOT NULL DEFAULT 'pending_acceptance',
          `total_price` DECIMAL(8, 2) NOT NULL,
          `updated_at` DATETIME(6) NOT NULL,
          `created_at` DATETIME(6) NOT NULL
        )
      SQL
      <<~SQL,
        ALTER TABLE `Orders`
          ADD INDEX `orders_status_index` (`status`)
      SQL
      <<~SQL,
        CREATE TABLE `OrderMenuItems` (
          `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `order_id` BIGINT UNSIGNED NOT NULL,
          `menu_item_id` BIGINT UNSIGNED NOT NULL,
          `quantity` BIGINT NOT NULL,
          `price_at_order` DECIMAL(8, 2) NOT NULL,
          `updated_at` DATETIME(6) NOT NULL,
          `created_at` DATETIME(6) NOT NULL
        )
      SQL
      <<~SQL,
        ALTER TABLE `OrderMenuItems`
          ADD UNIQUE `ordermenuitems_order_id_menu_item_id_unique` (`order_id`, `menu_item_id`),
          ADD INDEX `ordermenuitems_order_id_index` (`order_id`),
          ADD INDEX `ordermenuitems_menu_item_id_index` (`menu_item_id`)
      SQL
      <<~SQL,
        CREATE TABLE `ClientRecommendations` (
          `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `client_id` BIGINT UNSIGNED NOT NULL,
          `menu_item_id` BIGINT UNSIGNED NOT NULL,
          `updated_at` DATETIME(6) NOT NULL,
          `created_at` DATETIME(6) NOT NULL
        )
      SQL
      <<~SQL,
        ALTER TABLE `ClientRecommendations`
          ADD INDEX `clientrecommendations_client_id_index` (`client_id`)
      SQL
      <<~SQL,
        CREATE TABLE `ClientFavourites` (
          `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `client_id` BIGINT UNSIGNED NOT NULL,
          `menu_item_id` BIGINT UNSIGNED NOT NULL,
          `updated_at` DATETIME(6) NOT NULL,
          `created_at` DATETIME(6) NOT NULL
        )
      SQL
      <<~SQL,
        ALTER TABLE `ClientFavourites`
          ADD UNIQUE `clientfavourites_client_id_menu_item_id_unique` (`client_id`, `menu_item_id`),
          ADD INDEX `clientfavourites_client_id_index` (`client_id`)
      SQL
      <<~SQL,
        CREATE TABLE `Reviews` (
          `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `client_id` BIGINT UNSIGNED NOT NULL,
          `restaurant_id` BIGINT UNSIGNED NOT NULL,
          `order_id` BIGINT UNSIGNED NOT NULL,
          `text` VARCHAR(255) NOT NULL,
          `rating` INT NOT NULL,
          `updated_at` DATETIME(6) NOT NULL,
          `created_at` DATETIME(6) NOT NULL
        )
      SQL
      <<~SQL,
        ALTER TABLE `Reviews`
          ADD UNIQUE `reviews_client_id_restaurant_id_order_id_unique` (`client_id`, `restaurant_id`, `order_id`),
          ADD INDEX `reviews_client_id_index` (`client_id`),
          ADD INDEX `reviews_restaurant_id_index` (`restaurant_id`)
      SQL
      <<~SQL,
        CREATE TABLE `RestaurantLogoImages` (
          `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `restaurant_id` BIGINT UNSIGNED NOT NULL,
          `image_url` VARCHAR(255) NOT NULL,
          `updated_at` DATETIME(6) NOT NULL,
          `created_at` DATETIME(6) NOT NULL
        )
      SQL
      <<~SQL,
        CREATE TABLE `ClientItemInteractions` (
          `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `client_id` BIGINT UNSIGNED NOT NULL,
          `menu_item_id` BIGINT UNSIGNED NOT NULL,
          `interaction` ENUM('like', 'dislike') NOT NULL,
          `updated_at` DATETIME(6) NOT NULL,
          `created_at` DATETIME(6) NOT NULL
        )
      SQL
      <<~SQL,
        ALTER TABLE `ClientItemInteractions`
          ADD UNIQUE `clientiteminteractions_client_id_menu_item_id_unique` (`client_id`, `menu_item_id`),
          ADD INDEX `clientiteminteractions_client_id_index` (`client_id`)
      SQL
      <<~SQL,
        CREATE TABLE `Categories` (
          `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `title` VARCHAR(255) NOT NULL,
          `updated_at` DATETIME(6) NOT NULL,
          `created_at` DATETIME(6) NOT NULL
        )
      SQL
      <<~SQL,
        CREATE TABLE `MenuItemCategories` (
          `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `menu_item_id` BIGINT UNSIGNED NOT NULL,
          `category_id` BIGINT UNSIGNED NOT NULL,
          `updated_at` DATETIME(6) NOT NULL,
          `created_at` DATETIME(6) NOT NULL
        )
      SQL
      <<~SQL,
        ALTER TABLE `MenuItemCategories`
          ADD UNIQUE `menuitemcategories_menu_item_id_category_id_unique` (`menu_item_id`, `category_id`),
          ADD INDEX `menuitemcategories_category_id_index` (`category_id`)
      SQL

      # Foreign keys
      <<~SQL,
        ALTER TABLE `Reviews`
          ADD CONSTRAINT `reviews_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `Orders` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `Restaurants`
          ADD CONSTRAINT `restaurants_address_id_foreign` FOREIGN KEY (`address_id`) REFERENCES `Address` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `Orders`
          ADD CONSTRAINT `orders_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `Clients` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `OrderMenuItems`
          ADD CONSTRAINT `ordermenuitems_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `Orders` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `MenuItemImages`
          ADD CONSTRAINT `menuitemimages_menu_item_id_foreign` FOREIGN KEY (`menu_item_id`) REFERENCES `MenuItems` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `Reviews`
          ADD CONSTRAINT `reviews_restaurant_id_foreign` FOREIGN KEY (`restaurant_id`) REFERENCES `Restaurants` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `Clients`
          ADD CONSTRAINT `clients_address_id_foreign` FOREIGN KEY (`address_id`) REFERENCES `Address` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `MenuItemCategories`
          ADD CONSTRAINT `menuitemcategories_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `Categories` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `ClientItemInteractions`
          ADD CONSTRAINT `clientiteminteractions_menu_item_id_foreign` FOREIGN KEY (`menu_item_id`) REFERENCES `MenuItems` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `Clients`
          ADD CONSTRAINT `clients_account_id_foreign` FOREIGN KEY (`account_id`) REFERENCES `Accounts` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `Reviews`
          ADD CONSTRAINT `reviews_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `Clients` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `ClientRecommendations`
          ADD CONSTRAINT `clientrecommendations_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `Clients` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `ClientFavourites`
          ADD CONSTRAINT `clientfavourites_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `Clients` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `ClientRecommendations`
          ADD CONSTRAINT `clientrecommendations_menu_item_id_foreign` FOREIGN KEY (`menu_item_id`) REFERENCES `MenuItems` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `MenuItemCategories`
          ADD CONSTRAINT `menuitemcategories_menu_item_id_foreign` FOREIGN KEY (`menu_item_id`) REFERENCES `MenuItems` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `ClientItemInteractions`
          ADD CONSTRAINT `clientiteminteractions_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `Clients` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `Orders`
          ADD CONSTRAINT `orders_restaurant_id_foreign` FOREIGN KEY (`restaurant_id`) REFERENCES `Restaurants` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `MenuItems`
          ADD CONSTRAINT `menuitems_restaurant_id_foreign` FOREIGN KEY (`restaurant_id`) REFERENCES `Restaurants` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `ClientFavourites`
          ADD CONSTRAINT `clientfavourites_menu_item_id_foreign` FOREIGN KEY (`menu_item_id`) REFERENCES `MenuItems` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `OrderMenuItems`
          ADD CONSTRAINT `ordermenuitems_menu_item_id_foreign` FOREIGN KEY (`menu_item_id`) REFERENCES `MenuItems` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `Restaurants`
          ADD CONSTRAINT `restaurants_account_id_foreign` FOREIGN KEY (`account_id`) REFERENCES `Accounts` (`id`)
      SQL
      <<~SQL,
        ALTER TABLE `RestaurantLogoImages`
          ADD CONSTRAINT `restaurantlogoimages_restaurant_id_foreign` FOREIGN KEY (`restaurant_id`) REFERENCES `Restaurants` (`id`)
      SQL
      <<~SQL
        ALTER TABLE `Orders`
          ADD CONSTRAINT `orders_address_id_foreign` FOREIGN KEY (`address_id`) REFERENCES `Address` (`id`)
      SQL
    ]

    execute_statements(statements)
  end

  def down
    statements = [
      <<~SQL,
        ALTER TABLE `Orders` DROP FOREIGN KEY `orders_address_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `RestaurantLogoImages` DROP FOREIGN KEY `restaurantlogoimages_restaurant_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `Restaurants` DROP FOREIGN KEY `restaurants_account_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `OrderMenuItems` DROP FOREIGN KEY `ordermenuitems_menu_item_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `ClientFavourites` DROP FOREIGN KEY `clientfavourites_menu_item_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `MenuItems` DROP FOREIGN KEY `menuitems_restaurant_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `Orders` DROP FOREIGN KEY `orders_restaurant_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `ClientItemInteractions` DROP FOREIGN KEY `clientiteminteractions_client_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `MenuItemCategories` DROP FOREIGN KEY `menuitemcategories_menu_item_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `ClientRecommendations` DROP FOREIGN KEY `clientrecommendations_menu_item_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `ClientFavourites` DROP FOREIGN KEY `clientfavourites_client_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `ClientRecommendations` DROP FOREIGN KEY `clientrecommendations_client_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `Reviews` DROP FOREIGN KEY `reviews_client_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `Clients` DROP FOREIGN KEY `clients_account_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `ClientItemInteractions` DROP FOREIGN KEY `clientiteminteractions_menu_item_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `MenuItemCategories` DROP FOREIGN KEY `menuitemcategories_category_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `Clients` DROP FOREIGN KEY `clients_address_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `Reviews` DROP FOREIGN KEY `reviews_restaurant_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `MenuItemImages` DROP FOREIGN KEY `menuitemimages_menu_item_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `OrderMenuItems` DROP FOREIGN KEY `ordermenuitems_order_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `Orders` DROP FOREIGN KEY `orders_client_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `Restaurants` DROP FOREIGN KEY `restaurants_address_id_foreign`
      SQL
      <<~SQL,
        ALTER TABLE `Reviews` DROP FOREIGN KEY `reviews_order_id_foreign`
      SQL
      <<~SQL,
        DROP TABLE IF EXISTS `MenuItemCategories`
      SQL
      <<~SQL,
        DROP TABLE IF EXISTS `Categories`
      SQL
      <<~SQL,
        DROP TABLE IF EXISTS `ClientItemInteractions`
      SQL
      <<~SQL,
        DROP TABLE IF EXISTS `RestaurantLogoImages`
      SQL
      <<~SQL,
        DROP TABLE IF EXISTS `Reviews`
      SQL
      <<~SQL,
        DROP TABLE IF EXISTS `ClientFavourites`
      SQL
      <<~SQL,
        DROP TABLE IF EXISTS `ClientRecommendations`
      SQL
      <<~SQL,
        DROP TABLE IF EXISTS `OrderMenuItems`
      SQL
      <<~SQL,
        DROP TABLE IF EXISTS `Orders`
      SQL
      <<~SQL,
        DROP TABLE IF EXISTS `MenuItemImages`
      SQL
      <<~SQL,
        DROP TABLE IF EXISTS `MenuItems`
      SQL
      <<~SQL,
        DROP TABLE IF EXISTS `Restaurants`
      SQL
      <<~SQL,
        DROP TABLE IF EXISTS `Clients`
      SQL
      <<~SQL,
        DROP TABLE IF EXISTS `Address`
      SQL
      <<~SQL
        DROP TABLE IF EXISTS `Accounts`
      SQL
    ]

    execute_statements(statements)
  end

  private

  def execute_statements(statements)
    statements.each { |sql| execute(sql) }
  end
end
# rubocop:enable Metrics/ClassLength
