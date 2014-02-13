class LinksController < ApplicationController
  before_action :set_link, only: [:show, :info_action]

  # GET /links/1
  # GET /links/1.json
  def show
		redirect_to @link.uri
  end

  # GET /links/new
  def new
    @link = Link.new
  end

	# GET /links/info
	def info
	end

	# GET /links/info/1.json
	def info_action
		respond_to do |format|
			format.json { render json: { uri: @link.uri } }
		end
	end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(link_params)

    respond_to do |format|
      if @link.save
        format.html { redirect_to links_path, notice: 'Link was successfully created.' }
				format.json { render json: { short_link: root_url + @link.id.base62_encode } }
      else
        format.html { render action: 'new' }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
			require 'base62'
      @link = Link.find(params[:id].base62_decode)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:uri)
    end
end
