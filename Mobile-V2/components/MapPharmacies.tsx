import React from 'react';
import MapboxGL, { Camera, MapView, ShapeSource, SymbolLayer } from '@rnmapbox/maps';
import { View, Text, StyleSheet, Dimensions } from 'react-native';
import { usePharmacies } from '../hooks/usePharmacies';

// Initialisation de Mapbox avec votre token
MapboxGL.setAccessToken('pk.eyJ1IjoicGhhcm1hYm94ZGIiLCJhIjoiY2x2cDd6bDFtMDJkODJscjFrYnBnc3pwaSJ9.HGzdTcllcS7pG0a7At6wzg');

export const MapPharmacies = () => {
  const { pharmacies, loading, error } = usePharmacies();
  const [mapReady, setMapReady] = React.useState(false);

  if (loading) {
    return (
      <View style={styles.container}>
        <Text>Chargement de la carte...</Text>
      </View>
    );
  }

  if (error) {
    return (
      <View style={styles.container}>
        <Text>{error}</Text>
      </View>
    );
  }

  // Convertir les pharmacies en features GeoJSON
  const featureCollection = {
    type: 'FeatureCollection',
    features: pharmacies.map((pharmacie) => ({
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [
          pharmacie.situation_geographique?.data?.longitude || 2.3522,
          pharmacie.situation_geographique?.data?.latitude || 48.8566,
        ],
      },
      properties: {
        id: pharmacie.id,
        name: pharmacie.nom,
        // Ajoutez d'autres propriétés si nécessaire
      },
    })),
  };

  return (
    <View style={styles.page}>
      <View style={styles.container}>
        <MapView style={styles.map}>
          <Camera
            zoomLevel={12}
            centerCoordinate={[2.3522, 48.8566]}
          />
          
          
        </MapView>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
    page: {
      flex: 1,
      justifyContent: 'center',
      alignItems: 'center',
    },
    container: {
      height: Dimensions.get('window').height * 0.8,
      width: Dimensions.get('window').width * 0.9,
    },
    map: {
      flex: 1
    }
});