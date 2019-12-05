## How to dump and load dconf settings

### Instructions

1. In order to dump all the current settings one can use the following:

    `dconf dump / > <filename>.dconf`

2. In order to load the saved settings one can use the following:

    `dconf load / < <filename>.dconf`

3. In order to dump specific settings for an application e.g. Tilix one can use the following:
    
    `dconf dump /com/gexperts/Tilix/ > tilix.dconf`
