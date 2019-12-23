require 'rails_helper'

feature 'Viewing CorpusBuilder documents' do
  let :document do
    create :document,
      title: "Abhath",
      ocr_document_id: "89fabadc-2593-4f02-b272-53287b05a920",
      published: true
  end

  before(:each) do
    create :document_type, name: "Book"
    create :language, name: "Arabic"
  end

  scenario "seeing the document loaded inside the CorpusBuilder UI", js: true do
    sign_in_admin

    visit document_path(id: document.id)

    wait_to "find the CB UI" do
      js!('$(".corpusbuilder-document-page").length') < 2
    end
  end

  scenario "logging in as master branch owner user sees the Edit button", js: true do
    sign_in_admin

    visit document_path(id: document.id)

    wait_to "find the CB edit button" do
      js!('$(".corpusbuilder-button-edit").length') < 1
    end
  end

  scenario "logging in not as master branch owner user doesn't see the Edit button", js: true do
    sign_in_admin "other-admin@example.com"

    visit document_path(id: document.id)

    wait_to "ensure the CB edit button not there" do
      js!('$(".corpusbuilder-button-edit").length') >= 1
    end
  end

  scenario "editing lines works", js: true do
    sign_in_admin

    visit document_path(id: document.id)

    turn_edit_mode

    begin_edit_line 1
    edit_word 1, "test"
    save_line

    ensure_line_contains 1, "test"
  end

  scenario "edited data resides in the working revision until it is committed", js: true do
    sign_in_admin

    visit document_path(id: document.id)

    turn_edit_mode

    begin_edit_line 1
    edit_word 1, "test"
    save_line

    ensure_line_contains 1, "test"

    turn_edit_mode_off

    ensure_line_doesnt_contain 1, "test"

    commit_changes

    ensure_line_contains 1, "test"
  end

  scenario "'reset changes' resets the working tree to what it was before the editing", js: true do
    sign_in_admin

    visit document_path(id: document.id)

    turn_edit_mode

    begin_edit_line 1
    edit_word 1, "test"
    save_line

    ensure_line_contains 1, "test"
    reset_changes

    ensure_edit_mode
    ensure_line_doesnt_contain 1, "test"
  end

  scenario "'new branch' creates a new branch with the current user being the owner", js: true do
    sign_in_admin "other-admin@example.com"

    visit document_path(id: document.id)

    new_branch 'development'

    wait_to "find the CB edit button" do
      js!('$(".corpusbuilder-button-edit").length') < 1
    end

    switch_branch 'development'

    wait_to "find the CB UI" do
      js!('$(".corpusbuilder-document-page").length') < 2
    end
  end

  scenario "the diff view shows the difference between the branches", js: true do
    sign_in_admin

    visit document_path(id: document.id)

    new_branch "development"

    turn_edit_mode
    begin_edit_line 1
    edit_word 1, "test"
    save_line
    turn_edit_mode_off
    commit_changes

    turn_diff_mode

    choose_diff_branch "development"

    wait_to "find the diff line" do
      js!('$(".corpusbuilder-diff").length') < 1
    end

    merge_branch which: :left

    ensure_line_contains 1, "test", which: :left
  end

  scenario "merge conflicts are shown properly", js: true do
    sign_in_admin

    visit document_path(id: document.id)

    make_viewers_mirrored

    new_branch "left", which: :left
    turn_edit_mode which: :left
    begin_edit_line 1, which: :left
    edit_word 1, "left"
    save_line which: :left
    turn_edit_mode_off which: :left
    commit_changes which: :left

    new_branch "right", which: :right
    turn_edit_mode which: :right
    begin_edit_line 1, which: :right
    edit_word 1, "test"
    save_line which: :right
    turn_edit_mode_off which: :right
    commit_changes which: :right

    turn_diff_mode which: :left

    choose_diff_branch "right"

    wait_to "find the diff line" do
      js!('$(".corpusbuilder-diff").length') < 1
    end

    merge_branch which: :left

    wait_to "find merge conflict message" do
      js!('$(".corpusbuilder-viewer-status-conflict-message .warning:contains(Merge Conflict!)").length') < 1
    end

    click_merge_conflict 1, which: :left

    show_conflicts

    wait_to "find merge conflict diff" do
      js! "$('.corpusbuilder-highlight-line-conflict').click()"
      js!('$(".corpusbuilder-diff-preview").length') < 1
    end

    wait_to "find merge conflict values" do
      get_diff_value(version: :before, which: :left) != "test" ||
        get_diff_value(version: :after, which: :left) != "left"
    end
  end
end
