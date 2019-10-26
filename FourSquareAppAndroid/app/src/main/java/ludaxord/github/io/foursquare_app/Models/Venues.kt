package ludaxord.github.io.foursquare_app.Models

import android.util.Log
import com.github.kittinunf.fuel.Fuel
import com.github.kittinunf.fuel.android.extension.responseJson
import org.json.JSONObject

class Venues(userSettings: UserSettings) {

    var userSettings: UserSettings? = null

    init {
        this.userSettings = userSettings
    }

    fun venueListByLocation(lat: Double, long: Double,completionHandler: (JSONObject) -> Unit) {
        val clientID = userSettings!!.getPreferences("clientId")
        val clientSecret = userSettings!!.getPreferences("clientSecret")
        val url = "https://api.foursquare.com/v2/venues/search?client_id=$clientID&client_secret=$clientSecret&v=20180323&ll=$lat,$long"
        Fuel.get(url).responseJson { request, response, result ->
            if (response.responseMessage == "OK" && response.statusCode == 200) {
                val json = result.get().content
                val jsonObject = JSONObject(json)
                val resp = jsonObject.getJSONObject("response")
                completionHandler(resp)
            }
        }
    }

    fun venueListProvidedByUser(near: String ,completionHandler: (JSONObject) -> Unit) {
        val clientID = userSettings!!.getPreferences("clientId")
        val clientSecret = userSettings!!.getPreferences("clientSecret")
        val url = "https://api.foursquare.com/v2/venues/search?client_id=$clientID&client_secret=$clientSecret&v=20180323&near=$near"

        Fuel.get(url).responseJson { request, response, result ->
            if (response.responseMessage == "OK" && response.statusCode == 200) {
                val json = result.get().content
                val jsonObject = JSONObject(json)
                val resp = jsonObject.getJSONObject("response")
                completionHandler(resp)
            }
        }
    }
}
