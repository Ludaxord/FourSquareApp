package ludaxord.github.io.foursquare_app.Activities

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v4.app.ActivityCompat
import android.support.v4.content.ContextCompat
import android.util.Log
import android.view.WindowManager
import ludaxord.github.io.foursquare_app.Adapters.VenuesAdapter
import ludaxord.github.io.foursquare_app.Models.UserSettings
import ludaxord.github.io.foursquare_app.Models.VenueItems
import ludaxord.github.io.foursquare_app.Models.Venues

import android.location.Geocoder
import android.support.v7.app.ActionBar
import android.support.v7.widget.Toolbar
import ludaxord.github.io.foursquare_app.R
import java.util.*
import android.os.Build
import android.os.Handler
import android.text.Editable
import android.text.TextWatcher
import android.view.View
import android.widget.*


class MainActivity : AppCompatActivity() {

    private lateinit var listView: ListView
    private lateinit var adapter: VenuesAdapter
    private lateinit var locationManager: LocationManager
    private lateinit var locationListener: LocationListener

    val venuesArr = arrayListOf<VenueItems>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        listView = findViewById(R.id.places_list_view)
        val userSettings = UserSettings(this)
        userSettings.setPreferences("clientId", "<YOUR_CLIENT_ID>")
        userSettings.setPreferences("clientSecret", "<YOUR_CLIENT_SECRET>")
        window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN)
        getLocation(userSettings)
        placeTextWatcher(userSettings)
    }

    override fun onStart() {
        super.onStart()
    }

    private fun placeTextWatcher(userSettings: UserSettings) {
        val placeEditText = findViewById<EditText>(R.id.search_location)
        placeEditText.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(p0: Editable?) {
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                val near = p0.toString()
                val venues = Venues(userSettings)
                val ab = supportActionBar
                ab!!.title = "Near: $near"
                venuesArr.clear()
                locationManager.removeUpdates(locationListener)
                venues.venueListProvidedByUser(near) { resp ->

                    val ven = resp.getJSONArray("venues")
                    for (i in 0..(ven.length() - 1)) {
                        val venueItem = VenueItems()
                        val venue = ven.getJSONObject(i)
                        val name = venue.getString("name")
                        val location = venue.getJSONObject("location")
                        var distance = ""
                        var postalCode = ""
                        var city = ""
                        var state = ""
                        var country = ""
                        var address = ""
                        var lat = ""
                        var lng = ""

                        if (location.has("distance")) {
                            distance = location.getString("distance")
                        }
                        if (location.has("postalCode")) {
                            postalCode = location.getString("postalCode")
                        }
                        if (location.has("city")) {
                            city = location.getString("city")
                        }
                        if (location.has("state")) {
                            state = location.getString("state")
                        }
                        if (location.has("country")) {
                            country = location.getString("country")
                        }
                        if (location.has("address")) {
                            address = location.getString("address")
                        }
                        if (location.has("lat")) {
                            lat = location.getString("lat")
                        }
                        if (location.has("lng")) {
                            lng = location.getString("lng")
                        }

                        venueItem.name = name
                        venueItem.distance = distance
                        venueItem.postalCode = postalCode
                        venueItem.city = city
                        venueItem.state = state
                        venueItem.address = address
                        venueItem.country = country
                        venueItem.lat = lat
                        venueItem.lng = lng

                        venuesArr.add(venueItem)
                    }
                }
                Handler().postDelayed({
                    loadListView()
                }, 2000)
            }
        })
    }

    private fun listViewClick() {
        listView.isClickable = true
        listView.onItemClickListener = object : AdapterView.OnItemClickListener {
            override fun onItemClick(p0: AdapterView<*>?, p1: View?, p2: Int, p3: Long) {

                val intent = Intent(baseContext, MapsActivity::class.java)
                val lat = venuesArr[p2].lat
                val lng = venuesArr[p2].lng
                val name = venuesArr[p2].name
                intent.putExtra("lat", lat)
                intent.putExtra("lng", lng)
                intent.putExtra("name", name)
                startActivity(intent)
            }
        }
    }

    fun loadListView() {
        adapter = VenuesAdapter(this, venuesArr)
        listView.adapter = adapter
        adapter.notifyDataSetChanged()
        listViewClick()
    }

    private fun getLocation(userSettings: UserSettings) {

        val venues = Venues(userSettings)

        locationManager = (getSystemService(LOCATION_SERVICE) as LocationManager?)!!

        locationListener = object : LocationListener {
            override fun onLocationChanged(location: Location?) {

                val latitute = location!!.latitude
                val longitute = location.longitude
                val cityFromCoordinates = getCityFromCoordinates(latitute, longitute)
                val ab = supportActionBar
                ab!!.title = "Near: $cityFromCoordinates"

                venues.venueListByLocation(latitute, longitute) { resp ->
                    val ven = resp.getJSONArray("venues")
                    for (i in 0..(ven.length() - 1)) {
                        val venueItem = VenueItems()
                        val venue = ven.getJSONObject(i)
                        val name = venue.getString("name")
                        val loc = venue.getJSONObject("location")
                        var distance = ""
                        var postalCode = ""
                        var city = ""
                        var state = ""
                        var country = ""
                        var address = ""
                        var lat = ""
                        var lng = ""

                        if (loc.has("distance")) {
                            distance = loc.getString("distance")
                        }
                        if (loc.has("postalCode")) {
                            postalCode = loc.getString("postalCode")
                        }
                        if (loc.has("city")) {
                            city = loc.getString("city")
                        }
                        if (loc.has("state")) {
                            state = loc.getString("state")
                        }
                        if (loc.has("country")) {
                            country = loc.getString("country")
                        }
                        if (loc.has("address")) {
                            address = loc.getString("address")
                        }
                        if (loc.has("lat")) {
                            lat = loc.getString("lat")
                        }
                        if (loc.has("lng")) {
                            lng = loc.getString("lng")
                        }

                        venueItem.name = name
                        venueItem.distance = distance
                        venueItem.postalCode = postalCode
                        venueItem.city = city
                        venueItem.state = state
                        venueItem.address = address
                        venueItem.country = country
                        venueItem.lat = lat
                        venueItem.lng = lng

                        venuesArr.add(venueItem)
                    }
                }

                Handler().postDelayed({
                    loadListView()
                }, 2000)
            }

            override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {
            }

            override fun onProviderEnabled(provider: String?) {
            }

            override fun onProviderDisabled(provider: String?) {
            }

        }

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.INTERNET), 100)
            return
        }

        locationManager!!.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0L, 0f, locationListener)
        locationManager!!.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0L, 0f, locationListener)

    }

    fun getCityFromCoordinates(lat: Double, lng: Double): String {
        val gcd = Geocoder(this, Locale.getDefault())
        val addresses = gcd.getFromLocation(lat, lng, 1)
        return if (addresses.size > 0) {
            addresses[0].locality
        } else {
            "no location"
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        val userSettings = UserSettings(this)
        if (requestCode == 100) {
            when (grantResults[0]) {
                PackageManager.PERMISSION_GRANTED -> getLocation(userSettings)
                PackageManager.PERMISSION_DENIED -> Toast.makeText(applicationContext, "Permission denied", Toast.LENGTH_SHORT).show()

            }
        }
    }

}
