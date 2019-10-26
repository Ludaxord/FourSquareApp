package ludaxord.github.io.foursquare_app.Adapters

import android.annotation.SuppressLint
import android.content.Context
import android.opengl.Visibility
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.TextView
import ludaxord.github.io.foursquare_app.Models.VenueItems
import ludaxord.github.io.foursquare_app.R

class VenuesAdapter(context: Context, private val dataSource: ArrayList<VenueItems>) : BaseAdapter() {

    private val inflater: LayoutInflater = context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater

    override fun getItem(position: Int): Any {
        return dataSource[position]
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun getCount(): Int {
        return dataSource.size
    }

    @SuppressLint("ViewHolder", "SetTextI18n")
    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        val rowView = inflater.inflate(R.layout.places_list_view, parent, false)
        val nameTextView = rowView.findViewById<TextView>(R.id.name)
        val addressTextView = rowView.findViewById<TextView>(R.id.address)
        val cityTextView = rowView.findViewById<TextView>(R.id.city)
        val distanceTextView = rowView.findViewById<TextView>(R.id.distance)
        val venue = getItem(position) as VenueItems

        if (venue.name != "") {
            nameTextView.visibility = View.VISIBLE
            nameTextView.text = venue.name
        } else {
            nameTextView.visibility = View.GONE
        }
        if (venue.address != "") {
            addressTextView.visibility = View.VISIBLE
            addressTextView.text = venue.address
        } else {
            addressTextView.visibility = View.GONE
        }
        if (venue.city != "") {
            cityTextView.visibility = View.VISIBLE
            cityTextView.text = venue.city
        } else {
            cityTextView.visibility = View.GONE
        }
        if (venue.country != "") {
            cityTextView.visibility = View.VISIBLE
            if (venue.city != "") {
                cityTextView.text = "${cityTextView.text}, ${venue.country}"
            } else {
                cityTextView.text = venue.country
            }
        }
        if (venue.distance != "") {
            distanceTextView.visibility = View.VISIBLE
            distanceTextView.text = "${venue.distance}m"
        } else {
            distanceTextView.visibility = View.GONE
        }

        notifyDataSetChanged()

        return rowView
    }

}