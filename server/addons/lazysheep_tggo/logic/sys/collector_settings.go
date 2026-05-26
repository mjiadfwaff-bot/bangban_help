package sys

import "hotgo/addons/lazysheep_tggo/model"

const collectorRevealLinksStateKey = "collector.revealInBot"

func collectorRevealLinksEnabled(plugins map[string]*model.PluginConfig, bindingState map[string]any) bool {
	if bindingState != nil {
		if v, ok := bindingState[collectorRevealLinksStateKey].(bool); ok {
			return v
		}
	}
	if cfg := plugins["collector"]; cfg != nil && cfg.Settings != nil {
		if v, ok := cfg.Settings["revealInBot"].(bool); ok {
			return v
		}
	}
	return true
}
