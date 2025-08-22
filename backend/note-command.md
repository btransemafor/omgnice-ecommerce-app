npx sequelize-cli migration:generate --name create-banners
npx sequelize-cli db:migrate                      # chạy các migration

npx sequelize-cli seed:generate --name seed-banners
npx sequelize-cli db:seed:all                     # chạy toàn bộ seed
