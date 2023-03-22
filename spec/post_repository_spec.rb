require "post_repository"

def reset_posts_table
    seed_sql = File.read("spec/seeds_posts.sql")
    connection = PG.connect({ host: "127.0.0.1", dbname: "social_network_test" })
    connection.exec(seed_sql)
end

RSpec.describe PostRepository do
    before(:each) { reset_posts_table }

    it "gets all posts" do
        repo = PostRepository.new

        posts = repo.all

        expect(posts.length).to eq 2

        expect(posts[0].id).to eq '1'
        expect(posts[0].title).to eq 'baby photos'
        expect(posts[0].content).to eq 'six months progress'
        expect(posts[0].no_of_views).to eq '5'
        expect(posts[0].user_id).to eq '1'

        expect(posts[1].id).to eq '2'
        expect(posts[1].title).to eq 'cat photos'
        expect(posts[1].content).to eq 'two years old'
        expect(posts[1].no_of_views).to eq '3'
        expect(posts[1].user_id).to eq '2'
    end

    it "gets a soecific post" do
        repo = PostRepository.new

        post = repo.find(1)

        expect(post.id).to eq '1'
        expect(post.title).to eq 'baby photos'
        expect(post.content).to eq 'six months progress'
        expect(post.no_of_views).to eq '5'
        expect(post.user_id).to eq '1'

        post = repo.find(2)

        expect(post.id).to eq '2'
        expect(post.title).to eq 'cat photos'
        expect(post.content).to eq 'two years old'
        expect(post.no_of_views).to eq '3'
        expect(post.user_id).to eq '2'
    end

    it "creates a post" do
        repo = PostRepository.new

        post = Post.new

        post.title = 'dog photos'
        post.content = 'five years old'
        post.no_of_views = 6
        post.user_id = 1

        repo.create(post)
        posts = repo.all

        expect(posts.last.title).to eq 'dog photos'
        expect(posts.last.content).to eq 'five years old'
        expect(posts.last.no_of_views).to eq '6'
        expect(posts.last.user_id).to eq '1'
    end

    it "deletes a user" do
        repo = PostRepository.new

        post = repo.find(1)

        expect(post.id).to eq '1'
        expect(post.title).to eq 'baby photos'
        expect(post.content).to eq 'six months progress'
        expect(post.no_of_views).to eq '5'
        expect(post.user_id).to eq '1'

        repo.delete(post.id)

        posts = repo.all

        expect(posts.length).to eq 1

        expect(posts[0].id).to eq '2'
        expect(posts[0].title).to eq 'cat photos'
        expect(posts[0].content).to eq 'two years old'
        expect(posts[0].no_of_views).to eq '3'
        expect(posts[0].user_id).to eq '2'
    end

    it "updates a post" do
        repo = PostRepository.new

        post = repo.find(1)

        expect(post.id).to eq '1'
        expect(post.title).to eq 'baby photos'
        expect(post.content).to eq 'six months progress'
        expect(post.no_of_views).to eq '5'
        expect(post.user_id).to eq '1'

        post.content = 'first birthday!'
        post.no_of_views = 20

        repo.update(post)

        updated_post = repo.find(1)

        expect(updated_post.id).to eq '1'
        expect(updated_post.title).to eq 'baby photos'
        expect(updated_post.content).to eq 'first birthday!'
        expect(updated_post.no_of_views).to eq '20'
        expect(updated_post.user_id).to eq '1'
    end
end
