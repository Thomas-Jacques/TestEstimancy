class MaTablesController < ApplicationController
  before_action :set_ma_table, only: %i[ show edit update destroy ]

  # GET /ma_tables or /ma_tables.json
  def index
    @ma_tables = MaTable.all
  end

  # GET /ma_tables/1 or /ma_tables/1.json
  def show
  end

  # GET /ma_tables/new
  def new
    @ma_table = MaTable.new
  end

  # GET /ma_tables/1/edit
  def edit
  end

  # POST /ma_tables or /ma_tables.json
  def create
    @ma_table = MaTable.new(ma_table_params)

    respond_to do |format|
      if @ma_table.save
        format.html { redirect_to @ma_table, notice: "Ma table was successfully created." }
        format.json { render :show, status: :created, location: @ma_table }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ma_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ma_tables/1 or /ma_tables/1.json
  def update
    respond_to do |format|
      if @ma_table.update(ma_table_params)
        format.html { redirect_to @ma_table, notice: "Ma table was successfully updated." }
        format.json { render :show, status: :ok, location: @ma_table }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ma_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ma_tables/1 or /ma_tables/1.json
  def destroy
    @ma_table.destroy!

    respond_to do |format|
      format.html { redirect_to ma_tables_path, status: :see_other, notice: "Ma table was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  ################################################################
  def export_pptx
    # Crée une nouvelle présentation PowerPoint
    @deck = Powerpoint::Presentation.new
  
    # Création d'une slide d'introduction
    @deck.add_intro("Exportation des Enregistrements", "Généré à partir de MaTable")
  
    # Parcourt tous les enregistrements de la table MaTable
    MaTable.all.each_with_index do |entry, index|
      # Crée une slide textuelle pour chaque enregistrement
      title = "Enregistrement ##{index + 1}"
      content = [
        "Nom: #{entry.name}",
        "Âge: #{entry.age}",
        "Description: #{entry.description}"
      ]
      @deck.add_textual_slide(title, content)
    end
  
    # Enregistrer la présentation dans un fichier temporaire
    file_path = Rails.root.join("tmp", "ma_table_#{Date.today}.pptx")
    @deck.save(file_path.to_s)
  
    # Envoyer le fichier au client
    send_file file_path.to_s, type: 'application/vnd.openxmlformats-officedocument.presentationml.presentation', filename: "ma_table_#{Date.today}.pptx"
  end  
########################################################################
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ma_table
      @ma_table = MaTable.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def ma_table_params
      params.expect(ma_table: [ :name, :age, :description ])
    end
end
