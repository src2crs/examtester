function src2report_init()
    src2report_tasks = {}
    src2report_students = {}

    src2report_base_dir = "."
    src2report_submission_dir = "submissions"
end

function src2report_add_task(dir, name)
    local entry = {dir = dir, name = name}
    table.insert(src2report_tasks, entry)
end

function src2report_add_student(dir, name)
    local entry = {dir = dir, name = name}
    table.insert(src2report_students, entry)
end

function src2report_print_task_report(task_name, file_path)
    tex.sprint("\\taskreport{" .. task_name .. "}{" .. file_path .. "}")
end

function src2report_print_task_reports(submission_dir)
    for _, entry in ipairs(src2report_tasks) do
        local dir_name = src2report_escape_tex(entry.dir)
        local task_file = src2report_task_path(submission_dir, dir_name)
        local task_name = src2report_escape_tex(entry.name)
        print("Task directory: " .. task_file)
        src2report_print_task_report(task_name, task_file)
    end
end

function src2report_print_submission_report(student_name, submission_dir)
    tex.sprint("\\submissionreporthead{" .. student_name .. "}")
    src2report_print_task_reports(submission_dir)
end

function src2report_print_submission_reports()
    for _, entry in ipairs(src2report_students) do
        local dir_name = src2report_escape_tex(entry.dir)
        local submission_dir = src2report_submission_path(dir_name)
        local student_name = src2report_escape_tex(entry.name)
        src2report_print_submission_report(student_name, submission_dir)
    end
end

function src2report_escape_tex(str)
    return string.gsub(str, "_", "\\_")
end

function src2report_task_path(submission_dir, task_name)
    return submission_dir .. "/" .. task_name .. "/" .. task_name .. ".tex"
end

function src2report_submission_path(submission_dirname)
    return src2report_base_dir .. "/" .. src2report_submission_dir .. "/" .. submission_dirname
end
