import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { PositionService } from '../position.service';
import { Position } from '../position.types';
import { ModalSelectPositionService } from './modal-select-position.service';

@Component({
  selector: 'app-modal-select-position',
  templateUrl: './modal-select-position.component.html',
})
export class ModalSelectPositionComponent implements OnInit {
  id_position: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listPosition: Position[] = [];
  selectPositionForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _positionService: PositionService,
    private _modalSelectPositionService: ModalSelectPositionService
  ) {}

  ngOnInit(): void {
    /**
     * get the list of position
     */
    this._positionService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_positions: Position[]) => {
        this.listPosition = _positions;
      });
    /**
     * form
     */
    this.selectPositionForm = this._formBuilder.group({
      id_position: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectPositionForm.patchValue({
      id_position: this.selectPositionForm.getRawValue().id_position,
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
    this.id_position = this.selectPositionForm.getRawValue().id_position;
    this.patchForm();
  }
  /**
   * closeModalSelectPosition
   */
  closeModalSelectPosition(): void {
    this._modalSelectPositionService.closeModalSelectPosition();
  }
}
