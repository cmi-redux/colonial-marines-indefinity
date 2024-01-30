import { Chart, ProgressBar, Section } from '../components';
import { Window } from '../layouts';
import { useBackend } from '../backend';

export const DragonCoreStats = (props, context) => {
  const { data } = useBackend(context);
  const powerData = data.powerData.map((value, i) => [i, value]);
  const temperatureData = data.temperatureData.map((value, i) => [i, value]);
  const vesseltemperatureData = data.vesseltemperatureData.map((value, i) => [
    i,
    value,
  ]);
  const vesselcoolingData = data.vesselcoolingData.map((value, i) => [
    i,
    value,
  ]);
  const shieldData = data.shieldData.map((value, i) => [i, value]);
  const fuelcompressionData = data.fuelcompressionData.map((value, i) => [
    i,
    value,
  ]);
  const fuelData = data.fuelData.map((value, i) => [i, value]);
  const spentfuelData = data.spentfuelData.map((value, i) => [i, value]);
  const coolantData = data.coolantData.map((value, i) => [i, value]);
  return (
    <Window resizable theme="weyland" width={500} height={1000}>
      <Window.Content>
        <br />
        <Section title="Legend:">
          Reactor Power (%):
          <ProgressBar
            value={data.power}
            minValue={0}
            maxValue={100}
            color="yellow"
          />
          Temperature (°F):
          <ProgressBar
            value={data.temperature}
            minValue={0}
            maxValue={110000000}
            color="bad">
            {data.temperature} °F
          </ProgressBar>
          Vessel Temperature (°F):
          <ProgressBar
            value={data.vessel_temperature}
            minValue={0}
            maxValue={11000}
            color="bad">
            {data.vessel_temperature} °F
          </ProgressBar>
          Vessel Shield (Ps^2/R*L):
          <ProgressBar
            value={data.shields}
            minValue={0}
            maxValue={data.max_shields}
            color="bad">
            {data.shields} Ps^2/R*L
          </ProgressBar>
          Reactor Load (L):
          <ProgressBar
            value={data.fuel + data.spent_fuel + data.coolant}
            minValue={0}
            maxValue={data.reactor_capacity}
            color="bad">
            {data.fuel + data.spent_fuel + data.coolant} L
          </ProgressBar>
          <br />
          Fuel (L): {data.fuel} L | Spent Fuel (L): {data.spent_fuel} L |
          Coolant (L): {data.coolant} L
          <br />
          Fuel Compression (%): {data.fuelcompression}
        </Section>
        <Section fill title="Reactor Statistics:" height="400px">
          <Chart.Line
            fillPositionedParent
            data={powerData}
            rangeX={[0, powerData.length - 1]}
            rangeY={[0, 1500]}
            strokeColor="rgba(195, 195, 70, 1)"
            fillColor="rgba(195, 195, 70, 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={temperatureData}
            rangeX={[0, temperatureData.length - 1]}
            rangeY={[0, 110000000]}
            strokeColor="rgba(200, 0, 0, 1)"
            fillColor="rgba(200, 0, 0, 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={vesseltemperatureData}
            rangeX={[0, vesseltemperatureData.length - 1]}
            rangeY={[0, 11000]}
            strokeColor="rgba(200, 140, 120, 1)"
            fillColor="rgba(200, 140, 120, 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={vesselcoolingData}
            rangeX={[0, vesselcoolingData.length - 1]}
            rangeY={[0, 11000]}
            strokeColor="rgba(120, 170, 200, 1)"
            fillColor="rgba(120, 170, 200, 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={shieldData}
            rangeX={[0, shieldData.length - 1]}
            rangeY={[0, data.max_shields]}
            strokeColor="rgba(0, 5, 70, 1)"
            fillColor="rgba(0, 5, 70, 0.1)"
          />
        </Section>
        <Section fill title="Reactor Fuel Statistics:" height="200px">
          <Chart.Line
            fillPositionedParent
            data={fuelcompressionData}
            rangeX={[0, fuelcompressionData.length - 1]}
            rangeY={[0, 200]}
            strokeColor="rgba(45, 255, 45, 1)"
            fillColor="rgba(45, 255, 45, 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={fuelData}
            rangeX={[0, fuelData.length - 1]}
            rangeY={[0, data.reactor_capacity]}
            strokeColor="rgba(170, 75, 30, 1)"
            fillColor="rgba(170, 75, 30, 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={spentfuelData}
            rangeX={[0, spentfuelData.length - 1]}
            rangeY={[0, data.reactor_capacity]}
            strokeColor="rgba(100, 80, 30, 1)"
            fillColor="rgba(100, 80, 30, 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={coolantData}
            rangeX={[0, coolantData.length - 1]}
            rangeY={[0, data.reactor_capacity]}
            strokeColor="rgba(50, 50, 170, 1)"
            fillColor="rgba(50, 50, 170, 0.1)"
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
