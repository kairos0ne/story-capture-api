
module Api
    module V1
        class ExportController < ApiController
          before_action :require_login
  
          # GET /epics
          def index
            client = Client.find(params[:client_id])
            
            @stories = client.story.all

            respond_to do |format|
                format.html
                format.csv { render text: @stories.to_csv }
                format.xls { send_data @stories.to_csv }
            end

          end
  
          private
  
        end
    end
  end
  