require "user_repository"

def reset_users_table
    seed_sql = File.read("spec/seeds_users.sql")
    connection = PG.connect({ host: "127.0.0.1", dbname: "social_network_test" })
    connection.exec(seed_sql)
end

RSpec.describe UserRepository do
    before(:each) { reset_users_table }

    it "gets all users" do
        repo = UserRepository.new

        users = repo.all

        expect(users.length).to eq 2

        expect(users[0].id).to eq "1"
        expect(users[0].username).to eq 'Ray'
        expect(users[0].email_address).to eq 'ray@makers.com'

        expect(users[1].id).to eq "2"
        expect(users[1].username).to eq 'Jack'
        expect(users[1].email_address).to eq 'jack@makers.com'
    end

    it "gets a single user" do
        repo = UserRepository.new

        user = repo.find(1)

        expect(user.id).to eq "1"
        expect(user.username).to eq 'Ray'
        expect(user.email_address).to eq 'ray@makers.com'

        user = repo.find(2)

        expect(user.id).to eq "2"
        expect(user.username).to eq 'Jack'
        expect(user.email_address).to eq 'jack@makers.com'
    end

    it "creates a new user" do
        repo = UserRepository.new

        user = User.new

        user.username = 'Jay'
        user.email_address = 'jay@makers.com'

        repo.create(user)
        users = repo.all

        expect(users.last.username).to eq 'Jay'
        expect(users.last.email_address).to eq 'jay@makers.com'
    end

    it "delete a user" do
        repo = UserRepository.new

        user = repo.find(1)

        expect(user.id).to eq "1"
        expect(user.username).to eq 'Ray'
        expect(user.email_address).to eq 'ray@makers.com'

        repo.delete(user.id)

        users = repo.all

        expect(users.length).to eq 1

        expect(users[0].id).to eq "2"
        expect(users[0].username).to eq 'Jack'
        expect(users[0].email_address).to eq 'jack@makers.com'
    end

    it "updates a user" do
        repo = UserRepository.new

        user = repo.find(1)

        expect(user.id).to eq "1"
        expect(user.username).to eq 'Ray'
        expect(user.email_address).to eq 'ray@makers.com'

        user.email_address = 'ray2@makers.com'

        repo.update(user)

        updated_user = repo.find(1)

        expect(updated_user.id).to eq "1"
        expect(updated_user.username).to eq 'Ray'
        expect(updated_user.email_address).to eq 'ray2@makers.com'
    end
end
