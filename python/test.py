import folium
 
points_a = [[1,50], [1.2,50.3], [1.23, 50.7]]
points_z = [[1,51], [1.2,51.3], [1.23, 51.7]]

# Load map centred on average coordinates
ave_lat = sum(p[0] for p in points_a)/len(points_a)
ave_lon = sum(p[1] for p in points_a)/len(points_a)
my_map = folium.Map(location=[ave_lat, ave_lon], zoom_start=9)

#add a markers 'a'
for each in points_a:  
    my_map.add_child(folium.CircleMarker(location=each,
    fill='true',
    radius = 6,
    popup= 'Hi',
    fill_color='blue',
    color = 'clear',
    fill_opacity=1))

# add markers 'z'
for each in points_z:  
    my_map.add_child(folium.CircleMarker(location=each,
    fill='true',
    radius = 6,
    popup= 'Bye',
    fill_color='yellow',
    color = 'clear',
    fill_opacity=1))
    
# add lines
folium.PolyLine(points_a, color="green", weight=2.5, opacity=1).add_to(my_map)
folium.PolyLine(points_z, color="blue", weight=2.5, opacity=1).add_to(my_map)
 
# Save map
my_map.save("./lines_withmarker.html")