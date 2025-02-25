import React from 'react';
import {ActivityIndicator, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import {styles} from '@/assets/style/stylesheet';
import { ExternalPathString, Link, RelativePathString } from 'expo-router';
import { globalColors } from '@/assets/style/colors';



// Create Props interface
interface ButtonProps {
  styleType: 'btnPrimary' | 'btnSecondary' | 'btnSecondaryOutline';
  text: string;
  onPress?: () => void;
  isLink?: boolean;
  href?: RelativePathString | ExternalPathString;
  params?: object;
  isLoading?: boolean;
}


export const Button = ({styleType, text, isLink, href, onPress, params, isLoading} : ButtonProps) => (
  
  isLink && href ? (
    <Link href={{ 
      pathname: href, 
      params: { ...params }
     }} asChild>
      <TouchableOpacity>
        <Text style={styles[styleType]}>{isLoading ? <ActivityIndicator color={globalColors.base_10} /> : text}</Text>
      </TouchableOpacity>
    </Link>
  ) : (
    <TouchableOpacity onPress={onPress}>
      <Text style={styles[styleType]}>{isLoading ? <ActivityIndicator color={globalColors.base_10} /> : text}</Text>
    </TouchableOpacity>
  )
);
