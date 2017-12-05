// All credit goes to "Shigbeard" and "Trixter.xyz" as most of this script is created by them!
// 
// I myself decided to take on this script as I felt the addon is lacking features + this fits servers owners needs I find as it comes off as a very custom script 
//	
// you can find my steam profile here, but please refrain from adding (if possible haha): "http://steamcommunity.com/profiles/76561198211014256/"
//
//																																					https://www.youtube.com/watch?v=2YO96GFBSLw
local WebhookURL = "Paste Webhook URL here!" -- this video is about adding a bot, but it will still tell you how to do it, but in doubt just google it
local SteamWebAPIKey = "Paste Server Steam API Key Here!" -- same thing applies for this too, the original addon page has a perfect way of describing it(make sure you put your "server ip address" into the "Domain Site" name as the addon wont work:
//																		https://www.gmodstore.com/scripts/view/3277/discord-garrys-mod-chat-relay-script
function getAvatarFromJson( j_response ) 
    local t_response = util.JSONToTable( j_response )

    if ( !istable( t_response ) or !t_response.response ) then return false end
    if ( !t_response.response.players or !t_response.response.players[1] ) then return false end
    
    return t_response.response.players[1].avatarfull
end
 	function getAvatarURL( code, body, headers )														// don't touch this whole section
    if !body then
        local t_struct = {
            failed = function( err ) MsgC( Color(255,0,0), "HTTP error: " .. err ) end,
            method = "get",
            url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/",
            parameters = { key = SteamWebAPIKey, steamid = code },
            success = getAvatarURL
        }

        HTTP( t_struct )
    else
        return( getAvatarFromJson( body ) )
    end
end
	function sendChat(p_sender, s_text, b_teamChat)
    	if s_text == "!calladmin" then
			RunConsoleCommand("ulx", "psay", p_sender:Nick(), "All staff have recieved your request via [Discord], abuse and or time wasting of this command will result in punishment!") -- when the chat command above is called the player who called the command will be messaged by the server saying what is in this if statement, you can make this whatever
		end
		if !p_sender then return end

		if s_text != "!calladmin" then -- these are the chat commands that trigger the "Call Admin" chat command, you can change the "!calladmin" part to whatever command you wish!
			
		elseif s_text == "!calladmin" then -- these are the chat commands that trigger the "Call Admin" chat command, you can change the "!calladmin" part to whatever command you wish!

		local t_post = {
        content = "User currently on the server: " .. p_sender:Nick() .. ", has requested some Staff Assistance, please attend to this request ASAP!", -- this is the chat message that displays in discord!
        username = "(Pending) " .. (p_sender:Nick() or "Unknown"), -- this is the user name of the "Bot" that appears when the chat command is used
        avatar_url = getAvatarURL( p_sender:SteamID64() )
    }
    local t_struct = {
        failed = function( err ) MsgC( Color(255,0,0), "HTTP error: " .. err ) end,
        method = "post",
        url = WebhookURL,
        parameters = t_post,
        type = "application/json; charset=utf-8" 
    }

    HTTP( t_struct )
	end
end
hook.Add("PlayerSay","Discord_Webhook_Chat", sendChat)