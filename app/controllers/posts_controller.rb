class PostsController < InheritedResources::Base

  def create
    post = PostCreateMutation.run(params[:post])

    if post.success?
      redirect_to resource_path(post.result)
    else
      render :edit
    end
  end

  #def build_resource_params
  #  [params.require(resource_instance_name).permit!]
  #end

end