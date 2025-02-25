import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import {styles} from '@/assets/style/stylesheet';
import { globalColors } from '@/assets/style/colors';

interface TitleProps {
  text: string;
  variant: 'h1' | 'h2' | 'h3' | 'h4' | 'h5' | 'h6';
}

export const Title = ({ text, variant }: TitleProps) => {
  return (
      <Text style={styles[variant]}>{text}</Text>
  );
};
