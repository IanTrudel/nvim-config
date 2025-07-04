vim.cmd('highlight clear')
vim.cmd('syntax reset')
vim.g.colors_name = 'seventies'

-- Define colors with improved contrast
local colors = {
    bg = '#2D2A0A',      -- Darker Olive background for better contrast
    fg = '#FAF3DD',      -- Brighter Cream text
    keyword = '#FFC107', -- Brighter Mustard Yellow
    comment = '#B5C178', -- Lighter Olive for better visibility
    string = '#7FBF4F',  -- Brighter Avocado Green
    number = '#FF8C42',  -- More vivid Orange
    operator = '#F2E1C2',-- Warmer Beige
    identifier = '#E75B26', -- Stronger Red-Orange for identifiers
}

-- Apply colors
local function highlight(group, fg, bg, attr)
    local cmd = 'highlight ' .. group .. ' guifg=' .. (fg or 'NONE') .. ' guibg=' .. (bg or 'NONE')
    if attr then
        cmd = cmd .. ' gui=' .. attr
    end
    vim.cmd(cmd)
end

-- Set UI elements
highlight('Normal', colors.fg, colors.bg)
highlight('CursorLine', nil, '#3A360F') -- Darker Olive for subtle highlight
highlight('CursorColumn', nil, '#3A360F')
-- highlight('LineNr', '#C2A65A', colors.bg) -- Warmer Gold for line numbers
highlight('LineNr', '#C2A65A', nil) -- Warmer Gold for line numbers
highlight('StatusLine', '#FFFFFF', '#E75B26', 'bold') -- Strong Orange-Red for status line
highlight('VertSplit', '#C2A65A', '#2D2A0A')
highlight('Pmenu', '#2D2A0A', '#FFC107')
highlight('PmenuSel', '#000000', '#FFC107', 'bold')

-- Set syntax highlighting
highlight('Comment', colors.comment, nil, 'italic')
highlight('String', colors.string, nil)
highlight('Number', colors.number, nil)
highlight('Keyword', colors.keyword, nil, 'bold')
highlight('Operator', colors.operator, nil)
highlight('Identifier', colors.identifier, nil)
highlight('Function', colors.identifier, nil)
highlight('Type', colors.keyword, nil)
highlight('Constant', colors.number, nil)

-- Additional highlights
highlight('MatchParen', '#FFC107', '#2D2A0A', 'bold')
highlight('Search', '#000000', '#FFC107', 'bold')
highlight('Visual', nil, '#E75B26')
