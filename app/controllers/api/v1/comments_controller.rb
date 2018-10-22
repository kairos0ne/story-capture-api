module Api
    module V1
  
      class CommentsController < ApiController
        before_action :require_login
        before_action :get_jira_client
        before_action :set_project, only: [:show, :update, :destroy]
  
        # GET /issuetypes
        def index
            if params[:key]
                issue = @jira_client.Issue.find(params[:key])
                items = []
                issue.comments.each do |comment|
                    items.push(comment.attrs)
                    @comments = items
                end
            
                render json: @comments 
            else
                render :json => {:error => "You need to provide a key for the project"}.to_json
            end
        end
        
        def show 
        
        end

        def create 
            issue = @jira_client.Issue.find(params[:key])
            comment = issue.comments.build
            text = params[:text]
            logger.debug "Comment attributes: #{comment}"
            begin
                comment.save!(:body => text)
            rescue JIRA::HTTPError => e
                puts e.response.code
                puts e.response.message
                puts e.response.body
            end

        end

        def update 
        
        end

        def destroy
        
        end

      end
    end
  end