import React from 'react';
import { View, Text, TouchableOpacity, Image, ImageSourcePropType } from 'react-native';
import { styles } from '@/assets/style/stylesheet';
import { useForm } from './Form';

interface RadioOption {
  label: string;
  value: string;
  image?: {src: ImageSourcePropType, size: number}; // Image optionnelle pour chaque option
}

interface InputRadioProps {
  name: string;
  label: string;
  options: RadioOption[];
  horizontal?: boolean; // Afficher les options horizontalement ou verticalement
  required?: boolean;
  errorMessage?: string;
}

export const InputRadio = ({
  name, 
  label, 
  options, 
  horizontal = false, 
  required = false,
  errorMessage = 'Ce champ est requis'
}: InputRadioProps) => {
  const { values, errors, setFieldValue, setFieldError } = useForm();
  
  const handleSelect = (value: string) => {
    setFieldValue(name, value);
    
    if (required && !value) {
      setFieldError(name, errorMessage);
    } else {
      setFieldError(name, '');
    }
  };

  return (
    <View className="mb-4">
      <Text className="text-base font-medium mb-1 text-gray-800">
        {label} {required && <Text className="text-red-500">*</Text>}
      </Text>
      
      <View className={`mt-2 ${horizontal ? 'flex-row flex-wrap' : 'flex-col'}`}>
        {options.map((option, index) => (
          <TouchableOpacity
            key={index}
            className={`mr-4 mb-2 px-4 py-3 rounded-lg border ${
              values[name] === option.value
                ? 'bg-blue-50 border-blue_100'
                : 'bg-white border-gray-300'
            }`}
            onPress={() => handleSelect(option.value)}
            activeOpacity={0.7}
          >
            <View className="flex-row items-center">
              {option.image && (
                <Image 
                  source={option.image.src} 
                  className="w-6 h-6 mr-2" 
                  resizeMode="contain"
                  style={{ width: option.image.size, height: option.image.size }}
                />
              )}
              <Text 
                className={` ${
                  values[name] === option.value
                    ? 'font-medium text-blue_100'
                    : 'text-grey_100'
                }`}
              >
                {option.label}
              </Text>
            </View>
          </TouchableOpacity>
        ))}
      </View>
      
      {errors[name] ? (
        <Text className="text-red-500 text-sm mt-1">{errors[name]}</Text>
      ) : null}
    </View>
  );
};