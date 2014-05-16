class SnippetsController < ApplicationController
  include Snippet::SearchScope

  before_action :set_snippet, only: [:show, :edit, :update, :destroy]

  # GET /snippets
  # GET /snippets.json
  def index
    # Simple page validation
    unless page_check(params[:page])
      return false
    end

    if params[:page].nil? || params[:page].blank?
      params[:page] = 1
    end

    @snippets = apply_scopes(Snippet).paginate(page: params[:page], per_page: 10).order('created_at DESC')

    # TODO: move it to other `method` and implement `button` that pass get params to `snippets#index`
    unless params['snippet'].nil?
      @snippets_count_texts = @snippets.count.to_s + ' ' + 'snippet'.pluralize(@snippets.count)
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /snippets/search
  def search
    @filter_button_text = 'Filters'
  end

  # GET /snippets
  def filter_by
    # TODO: implement later
  end

  # GET /snippets/1
  # GET /snippets/1.json
  def show
  end

  # GET /snippets/new
  def new
    @snippet = Snippet.new
    @submit_button_text = 'Add Snippet'
  end

  # GET /snippets/1/edit
  def edit
    @submit_button_text = 'Update Snippet'
  end

  # POST /snippets
  # POST /snippets.json
  def create
    @snippet = Snippet.new(snippet_params)

    unless lang_check(@snippet)
      return false
    end

    respond_to do |format|
      if @snippet.save
        format.html { redirect_to @snippet, notice: 'Snippet was successfully created.' }
        format.json { render action: 'show', status: :created, location: @snippet }
      else
        @submit_button_text = 'Add Snippet'
        format.html { render action: 'new' }
        format.json { render json: @snippet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /snippets/1
  # PATCH/PUT /snippets/1.json
  def update
    unless lang_check(Snippet.new(snippet_params))
      return false
    end

    respond_to do |format|
      if @snippet.update(snippet_params)
        format.html { redirect_to @snippet, notice: 'Snippet was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @snippet }
      else
        @submit_button_text = 'Update Snippet'
        format.html { render action: 'edit' }
        format.json { render json: @snippet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /snippets/1
  # DELETE /snippets/1.json
  def destroy
    @snippet.destroy
    respond_to do |format|
      format.html { redirect_to snippets_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_snippet
      @snippet = Snippet.find(params[:id])
    end

    # Auth snippet lang
    def lang_check(snippet)
      if !snippet.lang_id.nil? && !snippet.lang_id.blank? && !Lang.all.include?(snippet.lang)
        redirect_to(snippets_path, alert: 'Trying to crash things won\'t lead you anywhere! =)') # flash[:alert]
        return false
      end
      return true
    end

    # Pagination check
    def page_check(page)
      if !params[:page].nil? && !params[:page].blank? && params[:page].to_i < 1
        redirect_to(snippets_path)
        return false
      end
      return true
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def snippet_params
      params.require(:snippet).permit(:snippet, :lang_id, :description)
    end
end
