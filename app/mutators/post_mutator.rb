class PostMutator
  def self.create(attributes)
    author = attributes.delete('author')
    post = Post.new(attributes)
    user = User.find_or_create_by(login: author)
    post.user = user
    post.save!
    post
  rescue ActiveRecord::RecordInvalid
    post.errors.full_messages
  end
end
