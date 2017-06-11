class ProcessesController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Sys
  before_action :authenticate

  def index
    # get all the processes running on a system
    # params:
    # 1)process_name: name of the process if want to search
    # 2)order_by: asc/desc(Ascending/Descending)
    # 3)sort_by: name of column to sort by (default: resident_size)

    processes = []
    search_by = params[:search_by]
    order_by = params[:order_by] || 'asc'
    sort_by  = params[:sort_by] || 'resident_size'

    ProcTable.ps{ |p|
      processes << { 
        'pid' => p.pid, 
        'name' => p.name, 
        'resident_size'=> p.resident_size, 
        'virtual_size' => p.virtual_size 
      }
    }

    if search_by
      processes = processes.select{|p| (p['name'] =~ /#{search_by}/i)}
    end

    order_by = (order_by == 'asc' ? 1 : -1)
    processes = processes.sort_by{|p| p[sort_by] * order_by}

    render json: processes
  end

  def show
    # get detail of a single process.
    # params:
    # 1)id: id of the process of which detail is required

    process_id = params[:id].to_i

    # check if process id is valid
    if process_id == 0
      render json: {
        message: "Please pass a valid process id",
        success: false
      }
      return
    end

    process = ProcTable.ps(process_id)
    
    # return process if exists
    if process
      render json: process
    else
      render json: { 
        message: "No process exists with the given process id",
        success: false 
      }
    end
  end

  private
  
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      token == ENV['token']
    end
  end

end
