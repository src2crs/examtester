-- Lua Definitions for src2report.sty

-- Report class

Report = {
    tasks = {},
    students = {},
    base_dir = lfs.currentdir(),
    task_dir = "tasks",
    submission_dir = "submissions",
    src_file_ext = ".go"
}

-- Constructors and basic object management

function Report:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- Task and submission management

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
    tex.sprint("\\begin{multicols}{2}")
    self:print_task_reports(submission_dir)
    tex.sprint("\\end{multicols}")
end

function Report:print_submission_reports()
    for _, entry in ipairs(self.students) do
        local submission_dir = self:submission_path(entry.dir)
        local student_name = self:escape_tex(entry.name)
        self:print_submission_report(student_name, submission_dir)
    end
end

-- General typesetting for reports
-- Note: May not have to be methods.

function Report:print_task_report(task_name, file_path)
    tex.sprint("\\taskreport{" .. task_name .. "}{" .. file_path .. "}")
end

function Report:escape_tex(str)
    return string.gsub(str, "_", "\\_")
end

-- Path manipulation based on report directories

function Report:set_base_dir(base_dir)
    if string.sub(base_dir, 1, 1) ~= "/" then
        base_dir = lfs.currentdir() .. "/" .. base_dir
    end
    self.base_dir = base_dir
end

function Report:set_task_dir(task_dir)
    self.task_dir = task_dir
end

function Report:set_submission_dir(submission_dir)
    self.submission_dir = submission_dir
end

function Report:task_dir_path()
    return self.base_dir .. "/" .. self.task_dir
end

function Report:submission_dir_path()
    return self.base_dir .. "/" .. self.submission_dir
end

function Report:task_path(submission_dir, task_name)
    return submission_dir .. "/" .. task_name .. "/" .. task_name .. self.src_file_ext
end

function Report:submission_path(submission_dirname)
    return self:submission_dir_path() .. "/" .. submission_dirname
end

function Report:parse_task_dirs()
    for _, task_dir in ipairs(list_subdirectories(self:task_dir_path())) do
        self:add_task(task_dir, beautify(task_dir))
    end
end

function Report:submission_dirs()
    return list_subdirectories(self:submission_dir_path())
end

function Report:parse_submission_dirs()
    for _, submission_dir in ipairs(self:submission_dirs()) do
        self:add_student(submission_dir, beautify(submission_dir))
    end
end

function Report:parse_filesystem()
    self:parse_task_dirs()
    self:parse_submission_dirs()
end

-- Helper functions

function list_subdirectories(dir)
    local t = {}
    for entry in lfs.dir(dir) do
        if entry ~= "." and entry ~= ".." then
            local path = dir .. "/" .. entry
            if lfs.attributes(path, "mode") == "directory" then
                table.insert(t, entry)
            end
        end
    end

    table.sort(t)

    return t
end

-- Capitalize the first letter and replace "_" with " ".
function beautify(str)
    return string.gsub(string.gsub(str, "^%l", string.upper), "_", " ")
end

-- Create a new report object for the package to use.

report = Report:new()
