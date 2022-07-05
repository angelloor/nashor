import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { AreaService } from '../area.service';
import { Area } from '../area.types';
import { ModalSelectAreaService } from './modal-select-area.service';

@Component({
  selector: 'app-modal-select-area',
  templateUrl: './modal-select-area.component.html',
})
export class ModalSelectAreaComponent implements OnInit {
  id_area: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listArea: Area[] = [];
  selectAreaForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _areaService: AreaService,
    private _modalSelectAreaService: ModalSelectAreaService
  ) {}

  ngOnInit(): void {
    /**
     * get the list of area
     */
    this._areaService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_areas: Area[]) => {
        this.listArea = _areas;
      });
    /**
     * form
     */
    this.selectAreaForm = this._formBuilder.group({
      id_area: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectAreaForm.patchValue({
      id_area: this.selectAreaForm.getRawValue().id_area,
    });
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
  }
  /**
   * changeSelect
   */
  changeSelect(): void {
    this.id_area = this.selectAreaForm.getRawValue().id_area;
    this.patchForm();
  }
  /**
   * closeModalSelectArea
   */
  closeModalSelectArea(): void {
    this._modalSelectAreaService.closeModalSelectArea();
  }
}
