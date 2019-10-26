package ludaxord.github.io.foursquare_app.Activities

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v4.app.NavUtils
import android.util.Log
import android.view.MenuItem

import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions
import ludaxord.github.io.foursquare_app.R

class MapsActivity : AppCompatActivity(), OnMapReadyCallback {


    lateinit var placeName: String
    lateinit var placeLat: String
    lateinit var placeLng: String

    private lateinit var mapView: GoogleMap

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_maps)
        val mapFragment = supportFragmentManager
                .findFragmentById(R.id.map) as SupportMapFragment
        mapFragment.getMapAsync(this)
        val lat: String = intent.getStringExtra("lat")
        val lng: String = intent.getStringExtra("lng")
        placeLat = lat
        placeLng = lng
        val name: String = intent.getStringExtra("name")
        placeName = name
        val ab = supportActionBar
        ab!!.title = name
        ab.setDisplayHomeAsUpEnabled(true)
    }

    override fun onMapReady(p0: GoogleMap?) {
        mapView = p0!!
        val place = LatLng(placeLat.toDouble(), placeLng.toDouble())
        mapView.addMarker(MarkerOptions().position(place).title(placeName))
        mapView.moveCamera(CameraUpdateFactory.newLatLngZoom(place, 16.0f))
    }


    override fun onOptionsItemSelected(item: MenuItem?): Boolean {
        return when (item!!.itemId) {
            android.R.id.home -> {
                NavUtils.navigateUpFromSameTask(this)
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }
}
