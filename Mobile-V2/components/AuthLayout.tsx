import React from 'react';
import { View, Text, ActivityIndicator, Image } from 'react-native';
import { useAuthState } from '@/hooks/auth/useAuth';
import { styles, widthRender } from '@/assets/style/stylesheet';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';

const AuthLayout = ({ children }: { children: React.ReactNode }) => {
  const { user, loading } = useAuthState();

  if (loading) {
    return (
      <View style={styles.container}>
        <ActivityIndicator size="large" color="#0000ff" />
      </View>
    );
  }

  if (!user) {
    return (
      <View style={styles.container}>
        <Text style={styles.description}>Vous devez être connecté pour accéder à cette page.</Text>
      </View>
    );
  }


  const navItems = [
    { label: 'Jobs', path: '/titulaires', icon: 'campaign' },
    { label: 'Blabla', path: '/pharmaciens', icon: 'forum' },
    { label: 'Accueil', path: '/pharmacies', icon: 'home' },
    { label: 'Réseau', path: '/produits', icon: 'group' },
    { label: 'Annuaire', path: '/commandes', icon: 'sort' },
  ]

  return (
    <View style={[styles.container]}>
        <View style={[styles.flex, styles.flex_row]}>
            <View style={[styles.sidebar, widthRender(10)]}>
                {navItems.map((item) => (
                <View style={[styles.nav_item, styles.flex, styles.flex_row, styles.item_center]} key={item.path}>
                    <View style={{ paddingRight: 15 }}><MaterialIcons name={item.icon} size={25} /></View>
                    <View><Text>{item.label}</Text></View>
                </View>
                ))}
            </View>
            <View style={[widthRender(90)]}>
                <View style={[styles.bg_account_navbar, styles.flex, styles.flex_row, styles.items_end]}>
                    <Text><MaterialIcons name="person" size={25} /> Mon compte</Text>
                    <Text><MaterialIcons name="notifications" size={25} /> Mes notifications</Text>
                    <Text><MaterialIcons name="message" size={25} /> Messagerie</Text>
                </View>
                {children}
            </View>
        </View>
    </View>
  );
};

export default AuthLayout;