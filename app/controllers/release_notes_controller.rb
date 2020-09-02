class ReleaseNotesController < ApplicationController
  def index
    @release_notes = ReleaseNote.all.order(published_at: :desc).order(id: :desc)
  end
end
