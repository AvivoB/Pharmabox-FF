import { ROLES } from '@/common/constants/ROLES';
import React from 'react';
import { View, Text } from 'react-native';
import {Picker} from '@react-native-picker/picker';
import { styles } from '@/assets/style/stylesheet';

export const JobTitleSelect = ({  }) => {
  return (
    <View>
        <Picker
            style={styles.input_select}
        >
            {ROLES.map((role) => (
                <Picker.Item label={role} value={role} />
            ))}
        </Picker>
    </View>
  );
};
