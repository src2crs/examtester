Report = {
    tasks = {},
    students = {},
    base_dir = ".",
    submission_dir = "submissions",
    src_file_ext = ".go"
}

function Report:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Report:set_base_dir(base_dir)
    self.base_dir = base_dir
end

function Report:set_submission_dir(submission_dir)
    self.submission_dir = submission_dir
end

function Report:add_task(dir, name)
    local entry = {dir = dir, name = name}
    table.insert(self.tasks, entry)
end

function Report:add_student(dir, name)
    local entry = {dir = dir, name = name}
    table.insert(self.students, entry)
end

function Report:print_task_reports(submission_dir)
    for _, entry in ipairs(self.tasks) do
        local task_file = self:task_path(submission_dir, entry.dir)
        local task_name = self:escape_tex(entry.name)
        self:print_task_report(task_name, task_file)
    end
end

function Report:print_submission_report(student_name, submission_dir)
    tex.sprint("\\submissionreporthead{" .. student_name .. "}")
    self:print_task_reports(submission_dir)
end

function Report:print_submission_reports()
    for _, entry in ipairs(self.students) do
        local submission_dir = self:submission_path(entry.dir)
        local student_name = self:escape_tex(entry.name)
        self:print_submission_report(student_name, submission_dir)
    end
end

function Report:print_task_report(task_name, file_path)
    tex.sprint("\\taskreport{" .. task_name .. "}{" .. file_path .. "}")
end

function Report:escape_tex(str)
    return string.gsub(str, "_", "\\_")
end

function Report:task_path(submission_dir, task_name)
    return submission_dir .. "/" .. task_name .. "/" .. task_name .. self.src_file_ext
end

function Report:submission_path(submission_dirname)
    return self.base_dir .. "/" .. self.submission_dir .. "/" .. submission_dirname
end

report = Report:new()
