# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin_users = AdminUser.create([
    {username: "addy@novi.nl", password: "novi!0033"},
    {username: "bart@novi.nl", password: "novi!0033"},
    {username: "coen@novi.nl", password: "novi!0033"},
    {username: "dirk@novi.nl", password: "novi!0033"}])

api_user = ApiUser.create([
    {username: "alex@inholland.nl", password: "novi!0033", customer_id: 3, can_add_users: true}])

customers = Customer.create([
    {name: "Novi Hogeschool", deleted: false}])

qualification_types = QualificationType.create([
    {description: "Diploma"},
    {description: "Certificaat"}])

