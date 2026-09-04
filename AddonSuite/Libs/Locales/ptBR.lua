--[[-----------------------------------------------------------------------------
Namespace
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

local L = ns:NewLocale("ptBR"); if not L then return end

--[[-----------------------------------------------------------------------------
Locale Entries
-------------------------------------------------------------------------------]]

L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG"]                  = 'Janela de opções'
L["BINDING_NAME_ADDON_SUITE_OPTIONS_DLG_MINIMAP"]          = 'Janela de opções: Minimapa'

L['%s version %s by %s is loaded.']        = '%s versão %s por %s foi carregado.'
L['Type %s or %s for available commands.'] = 'Digite %s ou %s para ver os comandos disponíveis.'

L['Current Profile Color']            = ns.locale.profileNameColor
L['Current Profile Color::OutOfSync'] = ns.locale.profileNameColorOutOfSync
L['Current::Symbol::Options']   = ns.locale.greenIndicator
L['Current::Symbol::Minimap']   = ns.locale.checkMark

L['General']                  = 'Geral'
L['General::Desc']            = "Configurações gerais"
L['General Configuration']    = 'Configurações gerais'

L['General::Enable All::Button']           = ALL
L['General::Enable All::Button::Desc']     = 'Marca todos os addons abaixo.'
L['General::Disable All::Button']          = NONE
L['General::Disable All::Button::Desc']    = 'Desmarca todos os addons abaixo.'

L['Add-Ons::Desc']            = 'Para ativar ou desativar um addon, marque ou desmarque a caixa correspondente. Depois, clique em |cdf6F97FFRecarregar interface|r para aplicar as alterações.'
L['Reload UI']         = 'Recarregar interface'
L['Reload UI::Desc']   = 'Aplica e recarrega imediatamente |cfdE64750sem confirmação.|r'
L['Sync with Profile and Reload'] = 'Sincronizar com o perfil e recarregar'
L['Select Profile']           = 'Selecionar perfil'
L['Select Profile::Desc']     = 'Selecione um perfil para ativar. Você será solicitado a recarregar a interface. Esses perfis são gerenciados na aba Perfis.'

L['Global Setting']           = 'Configuração global'
L['Character Setting']        = 'Configuração do personagem'

L['Debugging']                = 'Depuração'
L['Debugging::Desc']          = 'Configurações de depuração para solução de problemas'
L['Debugging Configuration']  = 'Configurações de depuração'
L['Log Level']                = 'Nível de log'
L['Log Level::Desc']          = 'Um nível de log mais alto gera mais entradas:\nNíveis: ERROR(5), WARN(10), INFO(15), DEBUG(20), FINE(25), FINER(30), FINEST(35), TRACE(50)'
L['Categories']               = 'Categorias'
L['Current Profile']          = 'Perfil atual'
L['Debugging::Category::Enable All::Button']           = ALL
L['Debugging::Category::Enable All::Button::Desc']     = 'Marca todas as categorias de log abaixo. A categoria padrão (não mostrada aqui) está sempre ativa.'
L['Debugging::Category::Disable All::Button']          = NONE
L['Debugging::Category::Disable All::Button::Desc']    = 'Desmarca todas as categorias de log abaixo. A categoria padrão (não mostrada aqui) está sempre ativa.'

L['REQUIRES_RELOAD_PROFILE_CHANGED'] = 'As alterações de addons do seu perfil selecionado exigem uma recarga da interface para ter efeito. Isso ativará os addons marcados e desativará os desmarcados.\n\nRecarregar agora?'

L['Prompt me to Reload UI::Desc'] = 'Ative esta opção para receber um aviso perguntando se deseja recarregar a interface ao fechar a janela de opções, caso alterações que exijam ativação ou desativação de addons tenham sido feitas.'
L['Prompt me to Reload UI']       = 'Perguntar se devo recarregar a interface quando necessário'

L['Include Addon Changes in Reload Confirmation']       = 'Incluir alterações de addons na confirmação de recarga'
L['Include Addon Changes in Reload Confirmation::Desc'] = 'Ative para ver a lista de addons que serão ativados ou desativados dentro da caixa de confirmação de recarga.'

L['Confirm Reloads When Switching Profiles']       = 'Confirmar recargas ao trocar de perfil'
L['Confirm Reloads When Switching Profiles::Desc'] = 'Esta configuração adiciona uma etapa de confirmação antes de recarregar a interface ao trocar de perfil por meio de um clique esquerdo no menu do minimapa. Uma proteção contra alterações acidentais.'

L['Hide']                    = 'Ocultar'
L['Hide Minimap Icon']       = 'Ocultar ícone do minimapa'
L['Hide Minimap Icon::Desc'] = 'Alterna a visibilidade do ícone do addon no minimapa.'

L['Hide Minimap Icon TitanPanel']       = 'Ocultar ícone do minimapa ao adicionar ao TitanPanel'
L['Hide Minimap Icon TitanPanel::Desc'] = 'Oculta o ícone do addon no minimapa quando adicionado ao TitanPanel.'

L['View or switch profiles']      = 'Ver ou trocar de perfil'
L['Open minimap settings'] = 'Abrir configurações do minimapa'
L['View available commands']      = 'Ver comandos disponíveis'
L['Open settings']                = 'Abrir opções'
L['Command Lines']                = 'Linhas de comando'
L['Currently set to switch profiles %s a confirmation prompt.'] = 'Atualmente a troca de perfil ocorre %s.'

L['Add to Favorite']              = 'Adicionar aos favoritos'
L['Add to Favorite::Desc']        = "Ative esta opção para exibir o perfil atual no menu de troca de perfil do minimapa (clique esquerdo). Desative para ocultar o perfil do menu."
L['Minimap']                      = 'Minimapa'
L['Minimap::Desc']                = "Opções do minimapa"

L['Favorite Profiles']            = 'Perfis favoritos'
L['Favorite Profiles::Desc']      = 'Selecione os perfis favoritos para o menu do minimapa (clique esquerdo). Este menu permite alternar rapidamente entre conjuntos de addons.'
L['Switch Profile']               = 'Trocar perfil'

L['Reloads UI with confirmation']    = 'Recarrega a interface com confirmação'
L['Reloads UI without confirmation'] = 'Recarrega a interface sem confirmação'

L['Select profile to activate'] = 'Selecione abaixo um perfil para ativar'
L['without']                    = 'sem confirmação'
L['with']                       = 'com confirmação'
L['confirmation']               = 'confirmação'
L['No Confirmation']            = 'Sem confirmação'
L['Profile is out of sync']     = 'O perfil está fora de sincronia e requer uma recarga da interface.'
L['Click Key To Sync']          = 'Pressione ALT+clique esquerdo para sincronizar e recarregar'
L['ALT-LEFT-Click']             = 'ALT+clique esquerdo'
L['LEFT-Click']                 = 'Clique esquerdo'
L['RIGHT-Click']                = 'Clique direito'
L['SHIFT-RIGHT-Click']          = 'SHIFT+clique direito'

L['Profile Sync Status Indicator']       = 'Indicador de status de sincronização do perfil'
L['Profile Sync Status Indicator::Desc'] = 'Ative esta opção para usar codificação por |cfdE64750cor|r no ícone do minimapa, indicando visualmente se o seu perfil está sincronizado ou precisa de atualização.'

L['Open debug settings'] = 'Abrir configurações de depuração'

L['Enabled (After Reload)']  = 'Ativado (após recarregar)'
L['Disabled (After Reload)'] = 'Desativado (após recarregar)'

L['Limit Profile Name Characters']       = 'Limitar caracteres do nome do perfil...'
L['Limit Profile Name Characters::Desc'] = 'Define o número máximo de caracteres para exibir o nome do perfil à direita do ícone do addon no |cdf6F97FFTitan Panel|r. Se o nome exceder esse limite, será encurtado e terminará com reticências ("..."). Você pode ajustar esse valor entre 5 e 20 caracteres.'

L['Show Profile Name']            = 'Mostrar nome do perfil'
L['Show Profile Name::Desc']      = 'Ative esta opção para exibir o nome do perfil atual logo à direita do ícone no |cdf6F97FFTitan Panel|r.'
L['Titan Panel Settings']         = 'Configurações do Titan Panel'
L['Show Out of Sync Count']       = 'Mostrar contagem de addons fora de sincronia'
L['Show Out of Sync Count::Desc'] = 'Ative esta configuração para exibir no |cdf6F97FFTitan Panel|r a quantidade de addons atualmente fora de sincronia com o perfil ativo.'
L['Lib:']                         = 'Bibl.:'