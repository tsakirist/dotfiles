local M = {}

function M.setup()
    vim.cmd [[
        " Gradient highligting options
        " let s:scale = [
        "     \ '#f4468f', '#fd4a85', '#ff507a', '#ff566f', '#ff5e63',
        "     \ '#ff6658', '#ff704e', '#ff7a45', '#ff843d', '#ff9036',
        "     \ '#f89b31', '#efa72f', '#e6b32e', '#dcbe30', '#d2c934',
        "     \ '#c8d43a', '#bfde43', '#b6e84e', '#aff05b']

        " let s:gradient = map(s:scale, {i, fg -> wilder#make_hl(
        "     \ 'WilderGradient' . i, 'Pmenu', [{}, {}, {'foreground': fg}]
        "     \ )})

        " " Gradient highlighting
        "  \ 'highlights': {
        "  \   'gradient': s:gradient,
        "  \   'border': s:borderHighlight,
        "  \ },
        "  \ 'highlighter': wilder#highlighter_with_gradient([
        "  \   wilder#basic_highlighter(),
        "  \ ]),

        " Invoke the plugin only for these modes
        call wilder#setup({'modes': [':']})

        " Set functionality options
        call wilder#set_option('pipeline', [
        \  wilder#branch(
        \    wilder#cmdline_pipeline({
        \      'fuzzy': 1,
        \      'fuzzy_filter': wilder#lua_fzy_filter(),
        \    }),
        \    wilder#vim_search_pipeline(),
        \   ),
        \ ])

        " Set highlights
        let s:WilderAccent = wilder#make_hl('WilderAccent', 'Pmenu', [{}, {}, {'foreground': '#b48ead'}])
        let s:WilderBorder = wilder#make_hl('WilderBorder', 'Pmenu', [{}, {}, {'foreground': '#88c0d0'}])

        " Set theme options
        call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
            \ 'border': 'rounded',
            \  'highlighter': wilder#lua_fzy_highlighter(),
            \  'highlights': {
            \    'accent': s:WilderAccent,
            \    'border': s:WilderBorder,
            \  },
            \  'left': [
            \     ' ',
            \     wilder#popupmenu_devicons(),
            \  ],
            \  'right': [
            \     ' ',
            \     wilder#popupmenu_scrollbar(),
            \  ],
            \  })))
    ]]
end

return M
