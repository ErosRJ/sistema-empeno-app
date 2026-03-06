package com.inventario.casaempeno.controller;


import com.inventario.casaempeno.model.Cliente;
import com.inventario.casaempeno.repository.ClienteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/clientes") // <-- agrega /api
@CrossOrigin("*")
public class ClienteController {

    @Autowired
    private ClienteRepository clienteRepository;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody Cliente cliente) {
        if (clienteRepository.findByCorreo(cliente.getCorreo()) != null) {
            return ResponseEntity.badRequest().body(Map.of("error", "Correo ya registrado"));
        }
        cliente.setContrasena(passwordEncoder.encode(cliente.getContrasena()));
        Cliente saved = clienteRepository.save(cliente);
        return ResponseEntity.ok(saved);
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> body) {
        String correo = body.get("correo");
        String contrasena = body.get("contrasena");
        if (correo == null || contrasena == null) {
            return ResponseEntity.badRequest().body(Map.of("error", "correo y contrasena requeridos"));
        }

        Cliente c = clienteRepository.findByCorreo(correo);
        if (c == null) return ResponseEntity.status(404).body(Map.of("error", "Correo no encontrado"));

        if (!passwordEncoder.matches(contrasena, c.getContrasena())) {
            return ResponseEntity.status(401).body(Map.of("error", "Contraseña incorrecta"));
        }

        return ResponseEntity.ok(Map.of(
                "id", c.getId(),
                "nombreCompleto", c.getNombreCompleto(),
                "correo", c.getCorreo(),
                "telefono", c.getTelefono(),
                "estadoFinanciero", c.getEstadoFinanciero()
        ));
    }

    @GetMapping("/list")
    public ResponseEntity<?> listAll() {
        return ResponseEntity.ok(clienteRepository.findAll());
    }
}