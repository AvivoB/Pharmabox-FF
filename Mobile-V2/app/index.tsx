import { styles, widthRender } from "@/assets/style/stylesheet";
import { Text, View, Image, Alert } from "react-native";
import { Button } from "@/components/Button";
import { useState } from "react";
import { Input } from "@/components/Input";
import { Title } from "@/components/Title";
import { SelectInput } from "@/components/SelectInput";
import { ROLES } from "@/common/constants/ROLES";
import { AUTH_METHODS } from "@/common/constants/AUTH_METHODS";
import { JobTitleSelect } from "@/components/JobTitleSelect";


export default function Index() {
    const [step, setStep] = useState(0);

    return (
      <View style={styles.flex}>
        <View style={[styles.container, widthRender(70)]}>
            <View>
              <Text style={styles.description}>Créez votre compte Pharma-box et rejoignez le réseau social dédié à la pharmacie</Text>
            </View>
            <View>
              <JobTitleSelect />
            </View>
            <View>
              <SelectInput
                name="authMethod"
                label="Méthode d'authentification"
                items={AUTH_METHODS.map((method) => ({ value: method, label: method }))}
              />
            </View>
            <View>
              <Text>J'ai déjà un compte</Text>
            </View>
        </View>
        <View style={[styles.sidebar, widthRender(30)]}>
            {/* <Image source={require('@/assets/images/illustration-1.png')} /> */}
            <Text style={styles.h1}>Pharma-box</Text>
            <Text style={styles.h2}>Le réseau social de la pharmacie</Text>
        </View>
      </View>
    );
}
