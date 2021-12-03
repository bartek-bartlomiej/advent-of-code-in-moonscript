local Utils = require("utils")


local EyesColors = {}

EyesColors.NAMES = {
    AMBER = "amb",
    BLUE = "blu",
    BROWN = "brn",
    GREY = "gry",
    GREEN = "grn",
    HAZEL = "hzl",
    OTHER = "oth"
}

EyesColors.set = {}
for _, value in pairs(EyesColors.NAMES) do
    EyesColors.set[value] = true
end


local Fields = {}


Fields.NAMES = {
    BIRTH_YEAR = "byr",
    ISSUE_YEAR = "iyr",
    EXPIRATION_YEAR = "eyr",
    HEIGHT = "hgt",
    HAIR_COLOR = "hcl",
    EYE_COLOR = "ecl",
    PASSPORT_ID = "pid",
    COUNTRY_ID = "cid"
}


local function validate_year(v, min, max)
    if not string.find(v, "^%d%d%d%d$") then
        return false
    end

    local year = tonumber(v)
    return min <= year and year <= max
end


Fields.validators = {
    [Fields.NAMES.BIRTH_YEAR] = function (v)
        return validate_year(v, 1920, 2002)
    end,

    [Fields.NAMES.ISSUE_YEAR] = function (v)
        return validate_year(v, 2010, 2020)
    end,

    [Fields.NAMES.EXPIRATION_YEAR] = function (v)
        return validate_year(v, 2020, 2030)
    end,

    [Fields.NAMES.HEIGHT] = function (v)
        local height

        _, _, height = string.find(v, "^(%d%d%d)cm$")
        if height then
            height = tonumber(height)
            return 150 <= height and height <= 193
        end

        _, _, height = string.find(v, "^(%d%d)in$")
        if height then
            height = tonumber(height)
            return 59 <= height and height <= 76
        end

        return false
    end,

    [Fields.NAMES.HAIR_COLOR] = function (v)
        return string.find(v, "^#%x%x%x%x%x%x$")
    end,

    [Fields.NAMES.EYE_COLOR] = function (v)
        return EyesColors.set[v]
    end,

    [Fields.NAMES.PASSPORT_ID] = function (v)
        return string.find(v, "^%d%d%d%d%d%d%d%d%d$")
    end,

    [Fields.NAMES.COUNTRY_ID] = function (v)
        return true
    end,
}


local REQUIRED_FIELD_AMOUNT = 8
local IGNORED_FIELD = Fields.NAMES.COUNTRY_ID


local function has_required_fields(passport)
    local fields_amount = passport.fields_amount

    -- n = 0..7
    if fields_amount ~= REQUIRED_FIELD_AMOUNT then
        -- n = 0..6
        if fields_amount < REQUIRED_FIELD_AMOUNT - 1 then
            return false
        end

        -- n = 7
        if passport.fields[IGNORED_FIELD] then
            return false
        end
    end

    -- n = 8
    return true
end


local function has_valid_fields(passport)
    for field, value in pairs(passport.fields) do
        if not Fields.validators[field](value) then
            return false
        end
    end

    return true
end


local function count_valid(passports, is_valid)
    local valid_amount = 0

    for _, passport in pairs(passports) do
        if is_valid(passport) then
            valid_amount = valid_amount + 1
        end
    end

    return valid_amount
end


local function parse_line(line)
    local passport = {
        fields = {},
        fields_amount = 0
    }

    local fields_amount = 0
    for key, value in string.gmatch(line, "(%a%a%a):(%S+)") do
        passport.fields[key] = value
        fields_amount = fields_amount + 1
    end

    passport.fields_amount = fields_amount

    return passport
end


local function part_one(input)
    local function is_valid(passport)
        return has_required_fields(passport)
    end

    local passports = Utils.parse_input(input, parse_line)
    return count_valid(passports, is_valid)
end


local function part_two(input)
    local function is_valid(passport)
        return has_required_fields(passport) and has_valid_fields(passport)
    end

    local passports = Utils.parse_input(input, parse_line)
    return count_valid(passports, is_valid)
end


local PUZZLE = {
    year = 2020,
    day = 4
}

Utils.check(PUZZLE, part_one, 10, Utils.read_groups)
Utils.run(PUZZLE, part_one, Utils.read_groups)

Utils.check(PUZZLE, part_two, 6, Utils.read_groups)
Utils.run(PUZZLE, part_two, Utils.read_groups)
