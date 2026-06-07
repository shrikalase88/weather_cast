package com.wc.weather_cast

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class WeatherWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.home_widget_layout)

            val temperature = prefs.getString("temperature", "--°") ?: "--°"
            val city = prefs.getString("city_name", "Weather Cast") ?: "Weather Cast"
            val description = prefs.getString("description", "...") ?: "..."

            views.setTextViewText(R.id.tv_temperature, temperature)
            views.setTextViewText(R.id.tv_city, city)
            views.setTextViewText(R.id.tv_description, description)

            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            }
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.tv_temperature, pendingIntent)
            views.setOnClickPendingIntent(R.id.tv_city, pendingIntent)
            views.setOnClickPendingIntent(R.id.tv_description, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
