package ludaxord.github.io.foursquare_app.Models

import android.annotation.SuppressLint
import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.SharedPreferences
import android.preference.PreferenceManager


class UserSettings(context: Context) {


    private var preferences: SharedPreferences? = null
    private var editor: SharedPreferences.Editor? = null
    private var context: Context? = context

    init {
        this.context = context
        preferences = PreferenceManager.getDefaultSharedPreferences(this.context)
    }

    @SuppressLint("CommitPrefEdits")
    fun setPreferences(key: String, value: String) {
        editor = preferences!!.edit()
        editor!!.putString(key, value)
        editor!!.apply()
    }

    @SuppressLint("CommitPrefEdits")
    fun getPreferences(key: String): String {
        editor = preferences!!.edit()
        val value = preferences!!.getString(key, "")
        return value
    }

}