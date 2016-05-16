class Api::V1::SprintsController < Api::BaseController
  load_and_authorize_resource

  def show
    @assignees = @sprint.assignees
    row_start = 3
    row_end = @assignees.size + row_start if @assignees.any?
    col_start = 15
    col_start_sum = 17
    style_default = "0;0;000000;ffffff;left;none;0"

    cells = [
        {row: "1", col: "15", text: "Lost hours", calc: "Lost hours",
          style: style_default},
        {row: "2", col: "15", text: "WH", calc: "WH", style: style_default}
      ]

    if @assignees.any?
      @assignees.each do |assignee|
        tem = {row: row_start, col: col_start, text: assignee.user.name,
          calc: assignee.user.name,  style: style_default}
        cells.push tem
        row_start += 1
      end
    end

    col_char = convert_int_to_char 16
    tem = {row: "2", col: "16", text: get_formula_col(col_char, 3, @assignees.size + 2),
        calc: "",  style: style_default}
    cells.push tem

    (col_start_sum..26).each do |index|
      col_char = convert_int_to_char index
      tem = {row: "1", col: index, text: get_formula_col(col_char, 2, @assignees.size + 2),
        calc: "",  style: style_default}
      cells.push tem
    end

    #start date
    tem = {row: "17", col: "15", text: "Start Date", calc: "Start Date",  style: style_default}
    cells.push tem
    date = Sprint.first.start_date.strftime("%d-%m-%y") rescue nil
    tem = {row: "17", col: "16", text: date, calc: date,  style: style_default}
    cells.push tem

    #list date sprint
    start_date_sprint = @sprint.start_date.day.to_i
    end_date_sprint = start_date_sprint + 7
    start_col = 17
    (start_date_sprint..end_date_sprint).each do
      tem = {row: "18", col: start_col, text: start_date_sprint,
        calc: start_date_sprint,  style: style_default}
      cells.push tem
      start_col += 1
      start_date_sprint += 1
    end

    #Date row
    tem = {row: "18", col: "16", text: "Date", calc: "Date",  style: style_default}
    cells.push tem

    #Formula for date
    tem = {row: "19", col: "15", text: "=(Q21-P21)/Q21", calc: "",  style: style_default}
    cells.push tem

    #R
    tem = {row: "19", col: "16", text: "R", calc: "R",  style: style_default}
    cells.push tem

    tem = {row: "19", col: "17", text: "1", calc: "1",  style: style_default}
    cells.push tem

    formulas = [
      "=IF(ISERROR(VLOOKUP(TEXT(R18,'dddd'),$Z:$Z,1,FALSE)),$Q$19+Q19,Q19)",
      "=IF(ISERROR(VLOOKUP(TEXT(S18,'dddd'),$Z:$Z,1,FALSE)),$Q$19+R19,R19)",
      "=IF(ISERROR(VLOOKUP(TEXT(T18,'dddd'),$Z:$Z,1,FALSE)),$Q$19+S19,S19)",
      "=IF(ISERROR(VLOOKUP(TEXT(U18,'dddd'),$Z:$Z,1,FALSE)),$Q$19+T19,T19)",
      "=IF(ISERROR(VLOOKUP(TEXT(V18,'dddd'),$Z:$Z,1,FALSE)),$Q$19+U19,U19)",
      "=IF(ISERROR(VLOOKUP(TEXT(W18,'dddd'),$Z:$Z,1,FALSE)),$Q$19+V19,V19)",
      "=IF(ISERROR(VLOOKUP(TEXT(X18,'dddd'),$Z:$Z,1,FALSE)),$Q$19+W19,W19)"
    ]
    start_col = 18
    (0..6).each do |i|
      cal = i + 2
      tem = {row: "19", col: start_col, text: formulas[i], calc: cal,  style: style_default}
      cells.push tem
      start_col += 1
    end

    formulas = [
      "=1-(Q21-P21)/Q21",
      "=Q21",
      "=Q20-($P$2-Q1)",
      "=R20-($P$2-R1)",
      "=S20-($P$2-S1)",
      "=T20-($P$2-T1)",
      "=U20-($P$2-U1)",
      "=V20-($P$2-V1)",
      "=W20-($P$2-W1)"
    ]

    i = 0
    (16..25).each do |index|
      tem = {row: "20", col: index, text: formulas[i], calc: "",  style: style_default}
      cells.push tem
      i += 1
    end

    tems = [
      {row: "21", col: "1", text: "StoryID", calc: "StoryID",  style: style_default},
      {row: "21", col: "2", text: "TaskID", calc: "TaskID",  style: style_default},
      {row: "21", col: "3", text: "Task Name", calc: "Task Name",  style: style_default}
    ]
    tems.each do |tem|
      cells.push tem
    end

    tem = {row: "21", col: "16", text: "=Q21-P21", calc: "",  style: style_default}
    cells.push tem

    col_start_sum = 17
    (col_start_sum..26).each do |index|
      col_char = convert_int_to_char index
      count_activity = @sprint.activities.size
      tem = {row: "21", col: index, text: get_formula_col(col_char, 22, 22+count_activity),
        calc: "",  style: style_default}
      cells.push tem
    end

    sprint_json_array1 = {
      sheetid: "1", config: "", readonly: false, head: [], cells: cells
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
end
