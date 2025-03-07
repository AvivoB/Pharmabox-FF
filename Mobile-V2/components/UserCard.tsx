import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import React from 'react';
import { View, Text, Image, TouchableOpacity, StyleSheet } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';


export const UserCard = ({ item }) => {
  return (
    <View className='bg-white  m-2 rounded-lg'>
        <View className='flex flex-row p-4'>
            <View>
                <Image source={ item?.photoUrl ?? require('@/assets/images/Avatar.png')} style={{ width: 40, height: 40, borderRadius: 30 }} />
            </View>
            <View className='ml-2'>
                <Text className='text-xl font-semibold font-poppins'>{item?.nom +' '+ item?.prenom}</Text>
                <Text className='text-md'>{item?.poste}</Text>
            </View>
        </View>
        <View className="flex flex-row px-4 py-2">
            <MaterialIcons name='location-pin' size={30} ></MaterialIcons>
            <Text>{item?.city}, {item?.country}</Text>
        </View>
        <View className='p-4 bg-green_110 rounded-b-lg'>

        </View>
    </View>
  );
};
