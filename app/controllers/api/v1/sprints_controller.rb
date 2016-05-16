class Api::V1::SprintsController < Api::BaseController
  load_and_authorize_resource

  def show
    @assignees = @sprint.assignees
    @cells = []
    @activities = @sprint.activities
    start_col = Settings.sprint.start_col
    end_col = start_col + Settings.sprint.work - 1
    list_user
    lost_hour_day(start_col, end_col)
    date_work(start_col, end_col)
    estimate(start_col, end_col)
    remainning(start_col, end_col)
    # working_day = Settings.sprint.work
    # start_col = Settings.sprint.start_col
    # end_col = start_col + working_day

    # user_start_row = 3
    # user_end_row = user_start_row + size_assignee - 1

    # start_date = 10
    # start_work_row = 22
    # end_work_row = start_work_row + size_activity - 1


    # (start_col..end_col).each do |index|
    #   col_char = convert_int_to_char index
    #   estimate = create_sheet(21, index,
    #     get_formula_col(col_char, start_work_row, end_work_row), index)
    # end

    # (start_col..end_col-1).each do |index|
    #   col_char = convert_int_to_char index
    #   value = "=(" + col_char + "18+1)"
    #   date = create_sheet(18, index + 1, value, index)
    # end

    # (start_col..end_col-1).each do |index|
    #   col_char = convert_int_to_char index
    #   value = "=(" + col_char + "20-(E2-" + col_char + "1))"
    #   remainning = create_sheet(20, index + 1, value, "remain")
    # end




    # wh = get_formula_col("E", user_start_row, user_end_row)

    # est_exist = create_sheet(21, 5,
    #   get_formula_col("E", start_work_row, end_work_row), 1)
    # est_finish = create_sheet(21, 4, "=F21-E21", 5)
    # exist_percent = create_sheet(20, 5, "=E21/F21", 0.17)
    # finish_percent = create_sheet(20, 4, "=D21/F21", 0.83)

    tems = [
      {row: 1, col: 4, text: "Lost Hour"},
      {row: 2, col: 4, text: "WH"},
      # {row: 2, col: 5, text: wh, calc: "1"},
      {row: 17, col: 4, text: "Start Date"},
      # {row: 17, col: 5, text: start_date},
      {row: 18, col: 5, text: "Date"},
      {row: 18, col: 6, text:  "=E17", calc: 1},
      {row: 19, col: 6, text: "1"},
      {row: 19, col: 4, text: "W"},
      {row: 19, col: 5, text: "R"},
      # {row: 20, col: 6, text: "=F21", calc: "6"},
      {row: 21, col: 1, text: "StoryID"},
      {row: 21, col: 2, text: "TaskID"},
      {row: 21, col: 3, text: "Task Name"}
    ]
    tems.each do |tem|
      @cells.push tem
    end

    sprint_json_array1 = {
      sheetid: "1", config: "", readonly: false, cells: @cells,
      head: [
        {col: "1", width: "70", label: "A"},
        {col: "2", width: "70", label: "B"},
        {col: "3", width: "400", label: "C"},
        {col: "4", width: "70", label: "D"}
      ]
    }
    respond_with sprint_json_array1
  end

  def update
     respond_to do |format|
      format.json { render :json => {:message => "Success"} }
    end
  end

  private
  def get_formula_col col, start_row, end_row
    col_start = col + start_row.to_s
    col_end = col + end_row.to_s
    result = "=SUM(#{col_start}" + ":" + "#{col_end})"
  end

  def convert_int_to_char index
    col_char = (index + 64).chr
  end

  def create_sheet row, col, text, calc="", style=Settings.sprint.style
    tem = {row: row, col: col, text: text, calc: calc, style: style}
    @cells.push tem
  end

  def getname name
    result = name.split(" ")[-1]
  end

  def list_user
    start_col = Settings.sprint.start_col
    if @assignees.any?
      row = Settings.sprint.start_row.user
      @assignees.each do |assignee|
        name = getname(assignee.user.name)
        ass = create_sheet(row, start_col - 2, name, name)
        row += 1
      end
    end
  end

  def lost_hour_day start_col, end_col
    start_row = Settings.sprint.start_row.user
    end_row = start_row + @assignees.size - 1
    row = Settings.sprint.rows.losthour

    (start_col..end_col).each do |index|
      col_char = convert_int_to_char index
      lost_hour_day = create_sheet(row, index,
        get_formula_col(col_char, start_row, end_row), index)
    end

    end_lost_hour = convert_int_to_char end_col
    lost_hour = "=SUM(F1:" + end_lost_hour + "1)"
    create_sheet(row, start_col - 1, lost_hour, "50")
    wh = get_formula_col("E", start_row, end_row)
    create_sheet(row + 1, start_col -1, wh, "52")
  end

  def date_work start_col, end_col
    (start_col..end_col-1).each do |index|
      col_char = convert_int_to_char index
      value = "=(" + col_char + "18+1)"
      date = create_sheet(18, index + 1, value, index)
    end
  end

  def estimate start_col, end_col
    start_row = Settings.sprint.start_row.work
    end_row = start_row + @activities.size - 1
    (start_col-1..end_col).each do |index|
      col_char = convert_int_to_char index
      estimate = create_sheet(start_row - 1, index,
        get_formula_col(col_char, start_row, end_row), "est")
    end
  end

  def remainning start_col, end_col
    (start_col..end_col-1).each do |index|
      col_char = convert_int_to_char index
      value = "=(" + col_char + "20-(E2-" + col_char + "1))"
      remainning = create_sheet(20, index + 1, value, "remain")
    end
  end
end
