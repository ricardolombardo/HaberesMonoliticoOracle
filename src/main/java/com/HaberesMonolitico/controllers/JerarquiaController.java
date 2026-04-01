package com.HaberesMonolitico.controllers;

import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.HaberesMonolitico.entities.Jerarquia;
import com.HaberesMonolitico.services.JerarquiaService;

@RestController
@RequestMapping("/jerarquias")
public class JerarquiaController {

	@Autowired
	JerarquiaService jerarquiaService;
	
	@GetMapping("/getAll")
	public List<Jerarquia> obtenerTodos(){
		return jerarquiaService.listarJerarquias();
	}
	
	@GetMapping("/{id}")
	public Optional<Jerarquia> obtenerPorId(Long id){
		return jerarquiaService.obtenerJerarquiaPorId(id);
	}
	
    @PostMapping
    public Jerarquia crearJerarquia(@RequestBody Jerarquia jerarquia) {
        return jerarquiaService.guardarJerarquia(jerarquia);
    }
	
}
