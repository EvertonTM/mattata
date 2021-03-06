--[[
    Copyright 2017 wrxck <matthew@matthewhesketh.com>
    This code is licensed under the MIT. See LICENSE for details.
]]

local base64 = {}

local mattata = require('mattata')

function base64:init()
    base64.commands = mattata.commands(
        self.info.username
    ):command('base64')
     :command('b64').table
    base64.help = [[/base64 <text> - Converts a string of text into base64-encoded text. Alias: /b64.]]
end

function base64.encode(str)
    local bit = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((str:gsub(
        '.',
        function(x) 
            local r, bit = '', x:byte()
            for integer = 8, 1, -1 do
                r = r .. (bit % 2^integer - bit % 2^(integer - 1) > 0 and '1' or '0')
            end
            return r
        end
    ) .. '0000'):gsub(
        '%d%d%d?%d?%d?%d?',
        function(x)
            if (#x < 6) then
                return
            end
            local c = 0
            for integer = 1, 6 do
                c = c + (x:sub(integer, integer) == '1' and 2^(6 - integer) or 0)
            end
            return bit:sub(c + 1, c + 1)
        end
    ) .. ({ '', '==', '=' })[#str % 3 + 1])
end

function base64:on_message(message)
    local input = mattata.input(message.text)
    if not input then
        return mattata.send_reply(
            message,
            base64.help
        )
    end
    return mattata.send_message(
        message.chat.id,
        '<pre>' .. mattata.escape_html(base64.encode(input)) .. '</pre>',
        'html'
    )
end

return base64