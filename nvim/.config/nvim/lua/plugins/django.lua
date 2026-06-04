return  {
  'jamsjz/django.nvim',
  requires = {
    -- {'nvim-telescope/telescope.nvim'},  -- Optional
    {'voldikss/vim-floaterm'},          -- Optional
  },
  config = function()
    require('django').setup()
  end
}
